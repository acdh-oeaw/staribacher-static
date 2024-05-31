function getYear(item) {
  return item['date'].split('-')[0]
}

function createyearcell(val) {
  return (val !== undefined) ? `<div class="col-xs-6">\
  <button id="ybtn${val}" class="btn btn-light rounded-0 yearbtn" value="${val}" onclick="updateyear(this.value)">${val}</button>\
</div>` : '';
}

var calendarTypeData = calendarData.map(r =>
({
  startDate: new Date(r.date),
  endDate: new Date(r.date),
  name: r.name,
  linkId: r.id,
  color: r.id === false ? '#BADA55' : '#A63437'
}));


var startYear = 1677;

var years = Array.from(new Set(calendarData.map(getYear))).sort();
var yearsTable = document.getElementById('years-table');
for (var i = 0; i <= years.length; i++) {
  yearsTable.insertAdjacentHTML('beforeend', createyearcell(years[i]));
}
document.getElementById("ybtn" + startYear.toString()).classList.add("focus");


const calendar = new Calendar('#calendar', {
  startYear: startYear,
  language: "de",
  dataSource: calendarTypeData.filter(r => r.startDate.getFullYear() === startYear),
  displayHeader: false,
  clickDay: function (e) {
    //window.location = e.events[0].linkId;

    var entries = []
    $.each(e.events, function (key, entry) {
      entries.push(entry)
    });
    //window.location = ids.join();
    if (entries.length > 1) {
      let html = "<div class='modal' id='dialogForLinks' tabindex='-1' role='dialog' aria-labelledby='modalLabel' aria-hidden='true'>";
      html += "<div class='modal-dialog' role='document'>";
      html += "<div class='modal-content'>";
      html += "<div class='modal-header'>";
      html += "<h3 class='modal-title' id='modalLabel'>Links</h3>";
      html += "<button type='button' class='close' data-dismiss='modal' aria-label='Close'>";
      html += "<span aria-hidden='true'>&times;</span>";
      html += "</button></div>";
      html += "<div class='modal-body'><ul>";
      let numbersTitlesAndIds = new Array();
      for (let i = 0; i < entries.length; i++) {
        let linkTitle = entries[i].name;
        let linkId = entries[i].linkId;
        let numberInSeriesOfLetters = i + 1;
        numbersTitlesAndIds.push({ 'i': i, 'position': numberInSeriesOfLetters, 'linkTitle': linkTitle, 'id': linkId });
      }

      numbersTitlesAndIds.sort(function (a, b) {
        let positionOne = parseInt(a.position);
        let positionTwo = parseInt(b.position);
        if (positionOne < positionTwo) {
          return -1;
        }
        if (positionOne > positionTwo) {
          return 1;
        }
        return 0;
      });
      for (let k = 0; k < numbersTitlesAndIds.length; k++) {
        if (numbersTitlesAndIds[k].id === false) {
          html += "<li class='indent'>" + numbersTitlesAndIds[k].linkTitle + "</li>";
        } else {
          html += "<li class='indent'><a href='" + numbersTitlesAndIds[k].id + "'>" + numbersTitlesAndIds[k].linkTitle + "</a></li>";
        }
      }
      html += "</ul></div>";
      html += "<div class='modal-footer'>";
      html += "<button type='button' class='btn btn-secondary' data-dismiss='modal'>X</button>";
      html += "</div></div></div></div>";
      $('#dialogForLinks').remove();
      $('#loadModal').append(html);
      $('#dialogForLinks').modal('show');

    }
    else {
      if (entries.length > 0 && entries[0].linkId !== false) {
        window.location = entries[0].linkId;
      }
    }
  },
  renderEnd: function (e) {
    const buttons = document.querySelectorAll(".yearbtn");
    for (var i = 0; i < buttons.length; i++) {
      buttons[i].classList.remove('focus');
    }
    document.getElementById(`ybtn${e.currentYear}`).classList.add("focus");
  }
});
removeBlackDaysFromCalendar();

function updateyear(year) {
  calendar.setYear(year);
  const dataSource = calendarTypeData.filter(r => r.startDate.getFullYear() === parseInt(year));
  calendar.setDataSource(dataSource);
  removeBlackDaysFromCalendar();
}

function removeBlackDaysFromCalendar() {
  $('.day')
    .filter((i, e) => e.style.boxShadow == "black 0px -4px 0px 0px inset")
    .css('box-shadow', "rgb(166, 52, 55) 0px -4px 0px 0px inset, rgb(186, 218, 85) 0px -8px 0px 0px inset");
}
