/* 
##################################################################
Functions for generating pdf including all scans of current day
##################################################################
*/

var elements = document.getElementsByClassName('pb');

async function getDU(imgUrl) {
    let blob = await fetch(imgUrl).then(r => r.blob());
    let dataUrl = await new Promise(resolve => {
      let reader = new FileReader();
      reader.onload = () => resolve(reader.result);
      reader.readAsDataURL(blob);
    });
    return dataUrl;
}

function createFilename() {
    let url = elements[0].getAttribute("source");
    let begin = url.indexOf("staribacher");
    let end = /_\d{4}\.jp2/.exec(url).index;
    let reg = /\/Band\d{2}\/\d{2}_/;
    download_filename = url.substring(begin, end).replace(reg, "_");
    return download_filename;
}

async function generatePDF() {
    var doc = new jsPDF("p", "mm", "a4");
    var width = doc.internal.pageSize.getWidth();
    var height = doc.internal.pageSize.getHeight();

    // Create an array of promises to fetch all images
    const promises = Array.from(elements).map(async (element) => {
        let imgUrl = element.getAttribute("source");
        return getDU(imgUrl); // Get the dataUrl for each image
    });

    try {
        // Wait for all promises to resolve
        const dataUrls = await Promise.all(promises);

        // Add each image to the PDF
        dataUrls.forEach((dataUrl, index) => {
            if (index > 0) {
                doc.addPage();
            }
            doc.addImage(dataUrl, 'JPEG', 0, 0, width, height);
        });

        doc.save(createFilename() + ".pdf");
        // Set cookie so that loading image will vanish after successful download
        setCookie("downloadStarted", 1, Math.floor(Date.now() / 1000) + 20, '/', "", false, false);
    } catch (error) {
        console.error('Error generating PDF:', error);
    }
}

/* 
##################################################################
Loading animation during PDF download
##################################################################
*/

var setCookie = function(name, value, expiracy) {
    var exdate = new Date();
    exdate.setTime(exdate.getTime() + expiracy * 1000);
    var c_value = encodeURIComponent(value) + ((expiracy == null) ? "" : "; expires=" + exdate.toUTCString());
    document.cookie = name + "=" + c_value + '; path=/';
}
  
var getCookie = function(name) {
    let ARRcookies = document.cookie.split(";");
    for (let i = 0; i < ARRcookies.length; i++) {
        let x = ARRcookies[i].substring(0, ARRcookies[i].indexOf("="));
        let y = ARRcookies[i].substring(ARRcookies[i].indexOf("=") + 1);
        x = x.replace(/^\s+|\s+$/g, "");
        if (x == name) {
            console.log(x, ' ', y);
            return y ? decodeURI(decodeURIComponent(y.replace(/\+/g, ' '))) : y;
        }
    }
}

document.getElementById('downloadLink').addEventListener('click', function() {
    document.getElementById('fader').style.display = 'block';
    setCookie('downloadStarted', 0, 100); // Expiration could be anything... As long as we reset the value
    setTimeout(checkDownloadCookie, 1000); // Initiate the loop to check the cookie.
});
var downloadTimeout;
var checkDownloadCookie = function() {
    if (getCookie("downloadStarted") == 1) {
        setCookie("downloadStarted", "false", 100); //Expiration could be anything... As long as we reset the value
        document.getElementById('fader').style.display = 'none';
    } else {
        downloadTimeout = setTimeout(checkDownloadCookie, 1000); //Re-run this function in 1 second.
    }
}