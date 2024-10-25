/*
##################################################################
get container holding images urls as child elements
get container for osd viewer
get container wrapper of osd viewer
##################################################################
*/

// container.style.display = "none";
var height = screen.height;
var container = document.getElementById("container_facs_1");
var wrapper = document.getElementsByClassName("facsimiles")[0];
let isManualNavigation = false; // Flag to disable scroll event temporarily

function disableScrollEvent() {
    isManualNavigation = true;
}

function enableScrollEvent() {
    setTimeout(() => {
        isManualNavigation = false;
    }, 300); // Adjust the timeout as needed to match scroll behavior
}

/*
##################################################################
check if osd viewer is visible or not
if true get width from sibling container
if false get with from sibling container divided by half
height is always the screen height minus some offset
##################################################################
*/
if (!wrapper.classList.contains("fade")) {
    container.style.height = `${String(height / 2)}px`;
    // set osd wrapper container width
    var container = document.getElementById("section");
    if (container !== null) {
        var width = container.clientWidth;
    }
    var container = document.getElementById("viewer");
    container.style.width = `${String(width - 25)}px`;
} else {
    container.style.height = `${String(height / 2)}px`;
    // set osd wrapper container width
    var container = document.getElementById("section");
    if (container !== null) {
        var width = container.clientWidth;
    }
    var container = document.getElementById("viewer");
    container.style.width = `${String(width / 2)}px`;
}

/*
##################################################################
get all image urls stored in span el class tei-xml-images
creates an array for osd viewer with static images
##################################################################
*/
var element = document.getElementsByClassName('pb');
for (var i = 0; i < element.length; i++) {
    var elem = element[i];
    var source = elem.getAttribute('source');
        if (source && source.includes('/full/pct:100/0/default.jpg')) {
        var newSource = source.replace('/full/pct:100/0/default.jpg', '/full/!1024,1024/0/default.jpg');
        elem.setAttribute('source', newSource);
    }
}

var tileSources = [];
var img = element[0].getAttribute("source");
var imageURL = {
    type: 'image',
    url: img
};
tileSources.push(imageURL);
/*
##################################################################
initialize osd
##################################################################
*/

var viewer = OpenSeadragon({
    crossOriginPolicy: "Anonymous",
    id: 'container_facs_1',
    prefixUrl: 'https://cdnjs.cloudflare.com/ajax/libs/openseadragon/4.0.0/images/',
    sequenceMode: true,
    showNavigator: false,
    tileSources: tileSources
});

// add download button
let downloadButton = new OpenSeadragon.Button({
    tooltip: 'Download',
    srcRest: `https://cdnjs.cloudflare.com/ajax/libs/openseadragon/4.0.0/images/button_rest.png`,
    srcGroup: `https://cdnjs.cloudflare.com/ajax/libs/openseadragon/4.0.0/images/button_grouphover.png`,
    srcHover: `https://cdnjs.cloudflare.com/ajax/libs/openseadragon/4.0.0/images/button_hover.png`,
    srcDown: `https://cdnjs.cloudflare.com/ajax/libs/openseadragon/4.0.0/images/button_pressed.png`,
});

viewer.addButton(downloadButton);

/*
##################################################################
remove container holding the images url
##################################################################
*/
// setTimeout(function() {
//     document.getElementById("container_facs_2").remove();
// }, 500);

/*
##################################################################
index and previous index for click navigation in osd viewer
locate index of anchor element
##################################################################
*/
var idx = 0;
var prev_idx = -1 ;
/*
##################################################################
triggers on scroll and switches osd viewer image base on 
viewport position of next and previous element with class pb
pb = pagebreaks
##################################################################
*/

window.addEventListener("scroll", function(event) {
    if (isManualNavigation) return;
    var esiv = [];
    for (let el of element) {
        if (isInViewportAll(el)) {
            esiv.push(el);
        }
    }
    
    if (esiv.length != 0) {
        // first element in view
        var eiv = esiv[0];
        var eiv_idx = Array.from(element).findIndex((el) => el === eiv);
        
        idx = eiv_idx + 1;    
        // test if element is in viewport position to load correct image
        if (isInViewport(element[eiv_idx])) {
            loadNewImage(element[eiv_idx]);
        }
    }
    
});

/*
##################################################################
function to trigger image load and remove events
##################################################################
*/
function loadNewImage(new_item) {
    if (new_item) {
        // source attribute hold image item id without url
        var new_image = new_item.getAttribute("source");
        var old_image = viewer.world.getItemAt(0);
        if (old_image) {
            // get url from current/old image and replace the image id with
            // new id of image to be loaded
            // access osd viewer and add simple image and remove current image
            viewer.addSimpleImage({
                url: new_image,
                success: function(event) {
                    function ready() {
                        setTimeout(() => {
                            viewer.world.removeItem(viewer.world.getItemAt(0));
                        }, 200)
                    }
                    // test if item was loaded and trigger function to remove previous item
                    if (event.item) {
                        // .getFullyLoaded()
                        ready();
                    } else {
                        event.item.addOnceHandler('fully-loaded-change', ready());
                    }
                }
            });
        }
    }
}

/*
##################################################################
accesses osd viewer prev and next button to switch image and
scrolls to next or prev span element with class pb (pagebreak)
function for downloading current image
##################################################################
*/
var element_a = document.getElementsByClassName('pb');

for (var i = 0; i < element_a.length; i++) {
    var elem = element_a[i];
    var source = elem.getAttribute('source');
    if (source && source.includes('/full/pct:100/0/default.jpg')) {
        var newSource = source.replace('/full/pct:100/0/default.jpg', '/full/!1024,1024/0/default.jpg');
        elem.setAttribute('source', newSource);
    }
}

//var element_a = document.getElementsByClassName('pb');
var prev = document.querySelector("div[title='Previous page']");
var next = document.querySelector("div[title='Next page']");
var download = document.querySelector("div[title='Download']");
prev.style.opacity = 1;
next.style.opacity = 1;
download.style.opacity = 1;
download.innerHTML += '<i class="bi bi-download"></i>';

prev.addEventListener("click", () => {
    disableScrollEvent();
    if (idx > 0) {
        idx -= 1 ;
        element_a[prev_idx].scrollIntoView({ behavior: 'smooth', block: 'center' });
    } else {
        element_a[0].scrollIntoView({ behavior: 'smooth', block: 'center' });
        idx = 0 ;
    }
    prev_idx -= 1 ;
    enableScrollEvent();
});

next.addEventListener("click", () => {
    if (idx == 0 ) {
        element_a[1].scrollIntoView();
    }
    else if (idx < element_a.length) {
        element_a[idx].scrollIntoView();
    } else {
        element_a[idx - 1].scrollIntoView();
        idx -= 1 ;
    }
    prev_idx = idx - 1 ;
});


download.addEventListener("click", () => {
    var current_image = viewer.drawer.canvas.toDataURL("image/png");
    var link=document.createElement('a');
    link.href = current_image;
    
    /* handling index 0 */
    let download_idx = 0; 
    idx == 0 ? download_idx = 1 : download_idx = idx;
    let source = element_a[download_idx-1].getAttribute("source");

    /* creating file name for download */ 
    let begin = source.indexOf("staribacher");
    let end = source.indexOf(".jp2");
    let reg = /\/Band\d\d\//;
    let download_filename = source.substring(begin, end).replace(reg, "_");
    link.download = download_filename;

    link.click();
})


/*
##################################################################
function to check if element is close to top of window viewport
##################################################################
*/
function isInViewport(elem) {
    // Get the bounding client rectangle position in the viewport
    var bounding = elem.getBoundingClientRect();
    if (
        bounding.top <= 1200 &&
        bounding.bottom <= 600 &&
        bounding.top >= 0 &&
        bounding.bottom >= 0
    ) {
        return true;
    } else {
        return false;
    }
}

/*
##################################################################
function to check if element is anywhere in window viewport
##################################################################
*/
function isInViewportAll(elem) {
    // Get the bounding client rectangle position in the viewport
    var bounding = elem.getBoundingClientRect();
    // Checking part. Here the code checks if el is close to top of viewport.
    // console.log("Top");
    // console.log(bounding.top);
    // console.log("Bottom");
    // console.log(bounding.bottom);
    if (
        bounding.top >= 0 &&
        bounding.left >= 0 &&
        bounding.bottom <= (window.innerHeight || document.documentElement.clientHeight) &&
        bounding.right <= (window.innerWidth || document.documentElement.clientWidth)
    ) {
        return true;
    } else {
        return false;
    }
}