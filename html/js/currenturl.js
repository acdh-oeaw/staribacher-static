function showCurrentUrl() {
    var currentUrlElements = document.querySelectorAll('#currentURL');
    currentUrlElements.forEach(function(element) {
        element.textContent = window.location.href.replace(/#+$/g, ''); ;
    });
}

window.onload = showCurrentUrl;
