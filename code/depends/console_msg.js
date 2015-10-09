// возможность перехвата console.log и вывода на экран. пока не используется.

(function initConsoleLogDiv() {

  if (console.log.toDiv) {
    return;
  }


  function forceRepaint(siteHeader) {
//    siteHeader.style.display='none';
//    siteHeader.offsetHeight; // no need to store this anywhere, the reference is enough
//    siteHeader.style.display='block';  
  }

  function toString(x) {
    return typeof x === 'string' ? x : JSON.stringify(x);
  }

  var log = console.log.bind(console);
  var error = console.error.bind(console);
  var warn = console.warn.bind(console);

  var id = 'console-log-div';
  function createOuterElement() {
    var outer = document.getElementById(id);
    if (!outer) {
      outer = document.createElement('fieldset');
      outer.id = id;
      outer.title = "Press Ctrl+Shift+J to see all messages";
      document.body.appendChild(outer);
    }
    outer.classList.add('id');

    var style = outer.style;
    style.width = '100%';
    // style.minHeight = '200px';
    style.fontFamily = 'monospace';
    style.marginTop = '20px';
    style.whiteSpace = 'pre';
    style.border = '1px solid black';
    style.borderRadius = '5px';
    style.padding = '5px 10px';
    return outer;
  }

  var logTo = (function createLogDiv() {

    var outer = createOuterElement();

    var caption = document.createTextNode('console output');
    var legend = document.createElement('legend');
    legend.appendChild(caption);
    outer.appendChild(legend);

    var div = document.createElement('div');
    div.id = 'console-log-text';
    outer.appendChild(div);

    return div;
  }());
  
  function printToDiv() {
    try {
    var msg = Array.prototype.slice.call(arguments, 0)
      .map(toString)
      .join(' ');
    // var text = logTo.textContent;
    var text = "";
    logTo.textContent = text + msg + '\n';
    forceRepaint(logTo);
    // qmlEngine.rootObject.lastConsoleMessage = msg;
    }
    catch(e) {
      logTo.textContent = "err";
    };
  }

  function logWithCopy() {
    log.apply(null, arguments);
    printToDiv.apply(null, arguments);
  }

  console.log = logWithCopy;
  console.log.toDiv = true;

  console.error = function errorWithCopy() {
    error.apply(null, arguments);
    var args = Array.prototype.slice.call(arguments, 0);
    args.unshift('ERR:');
    printToDiv.apply(null, args);
  };

  console.warn = function logWarning() {
    warn.apply(null, arguments);
    var args = Array.prototype.slice.call(arguments, 0);
    args.unshift('WARNING:');
    printToDiv.apply(null, args);
  };

  window.addEventListener('error', function (err) {
    printToDiv('EXX:', err.message + '\n  ' + err.filename, err.lineno + ':' + err.colno);
  });

}());
