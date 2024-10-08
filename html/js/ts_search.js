var project_collection_name = "STB"
const typesenseInstantsearchAdapter = new TypesenseInstantSearchAdapter({
  server: {
    apiKey: "VSMye2GdRZvBRkpYnjXMUfZpOCiSOFLO",
    nodes: [
      {
        host: "typesense.acdh-dev.oeaw.ac.at",
        port: "443",
        protocol: "https",
      },
    ],
  },
  // The following parameters are directly passed to Typesense's search API endpoint.
  //  So you can pass any parameters supported by the search endpoint below.
  //  query_by is required.
  //  filterBy is managed and overridden by InstantSearch.js. To set it, you want to use one of the filter widgets like refinementList or use the `configure` widget.
  additionalSearchParameters: {
    query_by: "full_text",
    sort_by: 'notbefore:asc'
  },
});

const searchClient = typesenseInstantsearchAdapter.searchClient;
const search = instantsearch({
  searchClient,
  indexName: project_collection_name,
  routing: {
    router: instantsearch.routers.history(),
    stateMapping: instantsearch.stateMappings.simple(),
  },
});

function isNumeric(value) {
    return /^-?\d+$/.test(value);
}

function formatDate(timestamp, operator) {
	if (isNumeric(timestamp)) {
	  var date = new Date(timestamp * 1000);
	  let year = date.getFullYear();
	  let month  = date.getMonth() + 1;
	  let day = date.getDay() + 1;
    if (operator) {
      var date_rel = "";
      if (operator == "<=") {
        date_rel = "bis ";
      } else if (operator == ">=") {
        date_rel = "ab ";
      }
      date = date_rel + day + "-" + month + "-" + year;
    } else {
	  date = day + "-" + month + "-" + year;
    } 
	} else {
		date = timestamp 
  }
  return date
}

function renameLabel(label) {
  // Rename MC to Multiple Choice
  if(label === 'notbefore'){
          label = 'Datum'
      }
  if(label === 'persons'){
    label = 'Personen'
  }
  return label
}

search.addWidgets([
  instantsearch.widgets.searchBox({
    container: "#searchbox",
    placeholderSearch: true,
    searchable: true,
    searchablePlaceholder: "Volltextsuche",
    autofocus: true,
    label: "Volltextsuche",
    cssClasses: {
      form: "form-inline",
      input: "form-control col-md-11",
      submit: "btn",
      reset: "btn",
    },
  }),

  instantsearch.widgets.hits({
    container: "#hits",
    templates: {
      empty: "Keine Resultate für <q>{{ query }}</q>",
      item: `
              <h5><a href="{{rec_id}}#{{anchor_link}}">{{#helpers.snippet}}{ "attribute": "title", "highlightedTagName": "mark" }{{/helpers.snippet}}</a></h5>
              <p style="overflow:hidden;max-height:210px;">{{#helpers.snippet}}{ "attribute": "full_text", "highlightedTagName": "mark" }{{/helpers.snippet}}</p>
              <!-- <h5><span class="badge badge-primary">{{ project }}</span></h5> -->
          `,
    },
  }),

  instantsearch.widgets.pagination({
    container: "#pagination",
  }),

  instantsearch.widgets.stats({
    container: "#stats-container",
    templates: {
      text: `
            {{#areHitsSorted}}
              {{#hasNoSortedResults}}keine Treffer{{/hasNoSortedResults}}
              {{#hasOneSortedResults}}1 Treffer{{/hasOneSortedResults}}
              {{#hasManySortedResults}}{{#helpers.formatNumber}}{{nbSortedHits}}{{/helpers.formatNumber}} Treffer {{/hasManySortedResults}}
              aus {{#helpers.formatNumber}}{{nbHits}}{{/helpers.formatNumber}}
            {{/areHitsSorted}}
            {{^areHitsSorted}}
              {{#hasNoResults}}keine Treffer{{/hasNoResults}}
              {{#hasOneResult}}1 Treffer{{/hasOneResult}}
              {{#hasManyResults}}{{#helpers.formatNumber}}{{nbHits}}{{/helpers.formatNumber}} Treffer{{/hasManyResults}}
            {{/areHitsSorted}}
            gefunden in {{processingTimeMS}}ms
          `,
    },
  }),
  
  instantsearch.widgets.panel({
    collapsed: ({ state }) => {
      return state.query.length === 0;
    },
    templates: {
      header: 'Personen',
    },
  })(instantsearch.widgets.refinementList)({
    container: "#refinement-list-persons",
    attribute: "persons",
    attributeName: 'Personen',
    searchable: true,
    searchablePlaceholder: "nach Person suchen",
    label: "Personen",
    templates: {
      showMoreText(data, { html }) {
          return html`<span>${data.isShowingMore ? 'Weniger anzeigen' : 'Mehr anzeigen'}</span>`;
        },
    },
    showMore: true,
    showMoreLimit: 1000,
    limit: 10,
    cssClasses: {
      searchableInput: "form-control form-control-sm mb-2 border-light-2",
      searchableSubmit: "d-none",
      searchableReset: "d-none",
      showMore: "btn btn-secondary btn-sm align-content-center",
      list: "list-unstyled",
      count: "badge ml-2 badge-secondary ",
      label: "d-flex align-items-center text-capitalize",
      checkbox: "m-2",
    },
  }),

  instantsearch.widgets.rangeSlider({
    container: "#refinement-range-year",
    attribute: "notbefore",
    pips: false,
    tooltips: {
      format: v => formatDate(v),
    },
    cssClasses: {
      form: "form-inline",
      input: "form-control",
      submit: "btn",
    },
  }),

  instantsearch.widgets.pagination({
    container: "#pagination",
    padding: 2,
    cssClasses: {
      list: "pagination",
      item: "page-item",
      link: "page-link",
    },
  }),

  instantsearch.widgets.clearRefinements({
    container: "#clear-refinements",
    templates: {
      resetLabel: "Filter zurücksetzen",
    },
    cssClasses: {
      button: "btn",
    },
  }),

  instantsearch.widgets.currentRefinements({
    container: "#current-refinements",
    cssClasses: {
      delete: "btn",
      label: "badge",
    },
    transformItems(items) {
      return items.map(
        item => (
          {
            ...item,
            label: renameLabel(item.label),
            refinements: item.refinements.map(
              iitem => (
                {...iitem,
                label: formatDate(iitem.value, iitem.operator)}
              ),
            ),
          }
        ),
      ) ;
    },
  }),

  /*instantsearch.widgets.sortBy({
    container: "#sort-by",
    items: [
      { label: "standard", value: `${project_collection_name}` },
      { label: "chronologisch", value: `${project_collection_name}/sort/creation_date:asc, bv_doc_id_num:asc, doc_internal_orderval:asc` },
      { label: "umgekehrt chronologisch", value: `${project_collection_name}/sort/creation_date:desc, bv_doc_id_num:asc, doc_internal_orderval:asc` },
    ],
  }),*/

  instantsearch.widgets.configure({
    hitsPerPage: 8,
    attributesToSnippet: ["full_text"],
    //filters: function() { return document.getElementsByTagName("input").value },
  }),

]);
search.start();
