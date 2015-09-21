/**
 * Get URL contents. EXPORTED.
 * @param url {String} Url to fetch.
 * @private
 * @return {mixed} String of contents or false in errors.
 */

// временная штука для экспериментов со ссылками вида eval://чего-то-сделать
var _orig_getUrlContents = getUrlContents;
getUrlContents = function (url,skipErrorLogging) {
    if (url && url.startsWith && url.startsWith("eval://")) {
      var code = url.split("eval://")[1];
      var result;
      try {
        console.log("getUrlContents eval'ling code=",code);
        result = eval(code);
        console.log("result = ",result);
      } catch (e) {
        // same logic as with xhr
        if (!skipErrorLogging) 
          throw e;
        return false;
      }
  
      return result;
    }

    return _orig_getUrlContents(url,skipErrorLogging);
}    
     

/* 
getUrlContents = function (url,skipErrors) {
    var xhr = new XMLHttpRequest();
    xhr.open("GET", url, false);
    try {
      xhr.send(null);
      if (xhr.status != 200 && xhr.status != 0) { // 0 if accessing with file://
          if (!skipErrors)
            console.log("Retrieving " + url + " failed: " + xhr.responseText, xhr);
          return "";
      }
    } catch (e) {
       if (!skipErrors)
         console.log("Retrieving " + url + " failed with exception: ", e);
       return "";
    }
    return xhr.responseText;
}


QMLEngine.prototype.addLibraryPath = function( dirpath ) {
      if (!this.userAddedLibraryPaths) this.userAddedLibraryPaths = [];
      this.userAddedLibraryPaths.push( dirpath );
}

QMLEngine.prototype.libraryPaths = function() {
    return (this.userAddedLibraryPaths || []);
}
*/

/*
Qt.createComponent = function(name, executionContext)
{
    if (name in engine.components)
        return engine.components[name];

    var file = engine.$basePath + name;

    var src = getUrlContents(file,true);
    if (src=="") {
        var moredirs = engine.libraryPaths();
        for (var i=0; i<moredirs.length; i++) {
          file = moredirs[i] + name;
          src = getUrlContents(file,true);
          if (src != "") break;
        }
        if (src == "") 
          return undefined;
    }
        
    var tree = parseQML(src);

    if (tree.$children.length !== 1)
        console.error("A QML component must only contain one root element!");

    var component = new QMLComponent({ object: tree, context: executionContext });
    engine.components[name] = component;
    return component;
}
*/