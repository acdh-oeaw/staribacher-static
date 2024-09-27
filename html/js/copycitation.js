// From https://stackoverflow.com/a/45308151
var currentUrl = window.location.href ;
var currentDate = new Date().toLocaleDateString() ;

const copyTextToClipboard = (function initClipboardText() {
  const textarea = document.createElement('textarea');

  // Move it off-screen.
  textarea.style.cssText = 'position: absolute; left: -99999em';

  // Set to readonly to prevent mobile devices opening a keyboard when
  // text is .select()'ed.
  textarea.setAttribute('readonly', true);

  document.body.appendChild(textarea);

  return function setClipboardText(text) {
    textarea.value = text.concat(" ", currentUrl, " (Abfrage ", currentDate, ")")  ;
    // Check if there is any content selected previously.
    const selected = document.getSelection().rangeCount > 0 ?
      document.getSelection().getRangeAt(0) : false;

    // iOS Safari blocks programmatic execCommand copying normally, without this hack.
    // https://stackoverflow.com/questions/34045777/copy-to-clipboard-using-javascript-in-ios
    if (navigator.userAgent.match(/ipad|ipod|iphone/i)) {
      const editable = textarea.contentEditable;
      textarea.contentEditable = true;
      const range = document.createRange();
      range.selectNodeContents(textarea);
      const sel = window.getSelection();
      sel.removeAllRanges();
      sel.addRange(range);
      textarea.setSelectionRange(0, 999999);
      textarea.contentEditable = editable;
    }
    else {
      textarea.select();
    }

    try {
      const result = document.execCommand('copy');

      // Restore previous selection.
      if (selected) {
        document.getSelection().removeAllRanges();
        document.getSelection().addRange(selected);
      }
      displayGrowl(textarea.value) ;
      return result;
    }
    catch (err) {
      console.error(err);
      return false;
    }
  };
})();

function displayGrowl(text) {
  // Create a growl notification (customizable as needed)
  const notification = document.createElement('div');
  notification.textContent = `Copied: ${text}`;
  notification.style.cssText = `
    position: fixed;
    bottom: 20px;
    right: 20px;
    background: #333;
    color: #fff;
    padding: 10px 20px;
    border-radius: 5px;
    opacity: 0.9;
    z-index: 1000;
  `;
  document.body.appendChild(notification);

  // Remove the notification after 3 seconds
  setTimeout(() => {
    document.body.removeChild(notification);
  }, 3000);
}