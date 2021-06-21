// https://stackoverflow.com/questions/11381673/detecting-a-mobile-browser
window.isMobile =/iPhone|iPad|iPod|Android/i.test(navigator.userAgent);
// console.log("isMobile=",isMobile );

//////////// proxy
function formatSrc(src) {
  // console.log("formatSrc src=",src);
  if (src.indexOf("https://github.com/") == 0) {
     // обработка случая, когда загружают qmldir прямо из корня репозитория с пропуском метки /master, вынесена в qmlweb в import.js::readQmlDir, т.к. надо там фиксить урли файлов
     src = src.replace("/blob/","/");
     src = src.replace("https://github.com/","https://raw.githubusercontent.com/");
  }
  //src = src.replace("https://raw.githubusercontent.com","http://win.lineact.com/github");
  src = src.replace("https://raw.githubusercontent.com",window.location.protocol+"//viewlang.ru/github");
  
  if (src.indexOf("https://gist.github.com/") == 0) {
     // добрый дядя gist помещает имя файла в хэш-часть урля...
     var filepart = src.split( "#file-" );
     if (filepart[1]) filepart[1] = filepart[1].replace("-",".");
     // таким образом преобразовали 
     // https://gist.github.com/pavelvasev/d41aa7cedaf35d5d5fd1#file-apasha2-vl
     // https://gist.github.com/pavelvasev/d41aa7cedaf35d5d5fd1#file-apasha2.vl 
     
     src = filepart.join("/raw/");
     // а теперь получили https://gist.github.com/pavelvasev/d41aa7cedaf35d5d5fd1/raw/apasha2.vl 

     if (!src.match(/\/raw(\/*$|\/)/) ) src = src + "/raw";
     // проверим, есть ли уже вставка /raw/ в урль.
     // если на входе было только https://gist.github.com/pavelvasev/d41aa7cedaf35d5d5fd1
     // то теперь получили https://gist.github.com/pavelvasev/d41aa7cedaf35d5d5fd1/raw

     
     src = src.replace("https://gist.github.com/","https://gist.githubusercontent.com/");
     // и заменили на raw-версию с гиста:
     // https://gist.githubusercontent.com/pavelvasev/d41aa7cedaf35d5d5fd1/raw/apasha2.vl 
     // https://gist.githubusercontent.com/pavelvasev/d41aa7cedaf35d5d5fd1/raw
  }
  //src = src.replace("https://gist.githubusercontent.com","http://win.lineact.com/gist");
  src = src.replace("https://gist.githubusercontent.com","http://viewlang.ru/gist");
  //console.log("formatSrc result=",src);
  return src;
}

// redefine xhr ... http://stackoverflow.com/a/7778218
(function() {
    var proxied = window.XMLHttpRequest.prototype.open;
    window.XMLHttpRequest.prototype.open = function() {
        //console.log( arguments );
        arguments[1] = formatSrc( arguments[1] );
        return proxied.apply(this, [].slice.call(arguments));
    };
})();

//////////////////////////////////////////////////////
    
    function openFile( fileNameOrUrl ) {
      return Lazy.makeHttpRequest( fileNameOrUrl );
    }

var someGlobalCounter = 0;

var getCurrentScript = function () {
  if (document.currentScript) {
    return document.currentScript.src;
  } else {
    var scripts = document.getElementsByTagName('script');
    return scripts[scripts.length-1].src;

  }
};

var getCurrentScriptPath = function () {
  var script = getCurrentScript();
  var path = script.substring(0, script.lastIndexOf('/'));
  return path;
};

    
var la_require_prefix = getCurrentScriptPath() + "/";

function la_path( file ) 
{
  if (file.indexOf("://") >= 0 || file.indexOf(":/") >= 0) return formatSrc(file);
  return formatSrc(la_require_prefix + file);
}

var la_required = {};
function la_require(file,callback){
    //console.log("la_required[file]=",la_required[file],"file=",file);

    if (la_required[file] == "1" ) {
      return callback();
    }
    if (la_required[file]) { // script
      la_required[file].onreadystatechange = function() {
        if (this.readyState == 'complete') {
            la_required[file] = "1";        
            callback();
        }
      }
    }    

    var head=document.getElementsByTagName("head")[0];
    var script;

    if (/\.css$/.test(file)) {
      script=document.createElement('link');
      script.rel ='stylesheet';
      script.href = la_path(file);
    }
    else
    {
      script=document.createElement('script');
      script.type='text/javascript';
      script.src= la_path(file);
    }
    
    la_required[file] = script;

    //real browsers
    script.onload=callback;
    //Internet explorer
    script.onreadystatechange = function() {
        if (this.readyState == 'complete') {
            la_required[file] = "1";
            callback();
        }
    }
    head.appendChild(script);
}    

function la_unrequire( file ) {
  if (la_required[file]) {
    la_required[file] = null;
    removejscssfile( file, /\.css$/.test(file) ? "css" : "js" );
  }
}

function la_require_write(file){
    document.write('<script src="'+la_path(file)+'"></scr'+'ipt>')
}

function removejscssfile(filename, filetype){
    var targetelement=(filetype=="js")? "script" : (filetype=="css")? "link" : "none" //determine element type to create nodelist from
    var targetattr=(filetype=="js")? "src" : (filetype=="css")? "href" : "none" //determine corresponding attribute to test for
    var allsuspects=document.getElementsByTagName(targetelement)
    for (var i=allsuspects.length; i>=0; i--){ //search backwards within nodelist for matching elements to remove
    if (allsuspects[i] && allsuspects[i].getAttribute(targetattr)!=null && allsuspects[i].getAttribute(targetattr).indexOf(filename)!=-1)
        allsuspects[i].parentNode.removeChild(allsuspects[i]) //remove element by calling parentNode.removeChild()
    }
}
    
    function subtreeToScene( qmlObject ) {
        //console.log( "qmlObjectToScene for  ",qmlObject);
        
        var knownObject = false;
        
        // метка что это нерисуемый объект, а только контейнер (и все его подобъекты тоже тогда не рисуются)
        // if (!qmlObject.visual) return;
        
        if (qmlObject.visual && createSceneObject( qmlObject ))
           knownObject = true;
           
        for (var i = 0; i < qmlObject.children.length; i++) {
            var c = qmlObject.children[i];
            
            if (c.nesting) {
                // если это разворот
                // то запускаем его только если текущий объект нам не известен
                if (!knownObject && qmlObject.visual)
                    subtreeToScene(c);
                // вообще тут подумать крепко надо. что как когда разворачивается. и еще разворот по требованию пользователя.
                // удалять все nesting? если объект известен.
            }
            else
                subtreeToScene(c);
        }
    }

    function getParameterByName(name) {
      name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
      var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
        results = regex.exec(location.search);
      //return results === null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
      return results === null ? null : decodeURIComponent(results[1].replace(/\+/g, " "));
    }

    function getParameterByName2(name) {
      name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
      var regex = new RegExp("[\\?&]" + name + "--([^&#]*)"),
      results = regex.exec(location.search);
      return results === null ? null : decodeURIComponent(results[1].replace(/\+/g, " "));
    }    

    function updateQueryStringParameter(uri, key, value) {
       var re = new RegExp("([?&])" + key + "=.*?(&|$)", "i");
       var separator = uri.indexOf('?') !== -1 ? "&" : "?";
       if (uri.match(re)) {
          return uri.replace(re, '$1' + key + "=" + value + '$2');
       }
       else {
         return uri + separator + key + "=" + value;
       }
    }

function writeCookie(name,value,days) {
    if (days) {
        var date = new Date();
        date.setTime(date.getTime()+(days*24*60*60*1000));
        var expires = "; expires="+date.toGMTString();
    }
    else var expires = "";
    document.cookie = name+"="+value+expires+"; path=/";
}

function readCookie(name) {
    var nameEQ = name + "=";
    var ca = document.cookie.split(';');
    //console.log(ca);
    for(var i=0;i < ca.length;i++) {
        var c = ca[i];
        while (c.charAt(0)==' ') c = c.substring(1,c.length);
        if (c.indexOf(nameEQ) == 0) return c.substring(nameEQ.length,c.length);
    }
    return null;
}

function eraseCookie(name) {
    createCookie(name,"",-1);
}    

/*
Array.prototype.remove = function() {
    var what, a = arguments, L = a.length, ax;
    while (L && this.length) {
        what = a[--L];
        while ((ax = this.indexOf(what)) !== -1) {
            this.splice(ax, 1);
        }
    }
    return this;
};
*/

function removeA(arr) {
    var what, a = arguments, L = a.length, ax;
    while (L > 1 && arr.length) {
        what = a[--L];
        while ((ax= arr.indexOf(what)) !== -1) {
            arr.splice(ax, 1);
        }
    }
    return arr;
}
////////////////////////////////////////////////////////////////////////////////



////////////////////////////////////////////////////////////////////////////////

    // http://rosettacode.org/wiki/Vector_products#JavaScript
    function crossProduct(a, b) {
      return [a[1]*b[2] - a[2]*b[1],
              a[2]*b[0] - a[0]*b[2],
              a[0]*b[1] - a[1]*b[0]];
    }
    
    function diff(p1,p2) {
      return [ p1[0]-p2[0], p1[1]-p2[1],p1[2]-p2[2] ];
    }

    function vDiff(p1,p2) {
      return [ p1[0]-p2[0], p1[1]-p2[1],p1[2]-p2[2] ];
    }

    function vAdd(p1,p2) {
      return [ p1[0]+p2[0], p1[1]+p2[1],p1[2]+p2[2] ];
    }
    
    function dotProduct(a,b) {
      return a[0]*b[0] + a[1]*b[1] + a[2]*b[2];
    }    

    // http://evanw.github.io/lightgl.js/docs/vector.html
    function vNorm(a) {
      var l = vLen( a );
      if (l > 0.00001)
        return vMulScal( a, 1.0 / l );
      return a;
    }
    function vNormSelf(a) {
      var l = vLen( a );
      if (l < 0.000001) return;
      a[0] /= l;
      a[1] /= l;
      a[2] /= l;
      return a;
    }

    function vLen(a) {
      return Math.sqrt(dotProduct(a,a));
    }

    function vMul(a,b) {
      return [ a[0]*b[0], a[1]*b[1], a[2]*b[2] ];
    }

    function vMulScal(a,b) {
      return [ a[0]*b, a[1]*b, a[2]*b ];
    }
    
    function vMulScalar(a,b) {
      return [ a[0]*b, a[1]*b, a[2]*b ];
    }    

/*
        private void BuildBasis(Point3D p1, Point3D p2, out Vector3D v1, out Vector3D v2, out Vector3D v3)
        {
            v1 = p2 - p1;
            v1.Normalize();

            if (v1.X == 0)
                v2 = new Vector3D(0, -v1.Z, v1.Y);
            else
                v2 = new Vector3D(-v1.Y, v1.X, 0);
            v2.Normalize();

            v3 = Vector3D.CrossProduct(v1, v2);
        }
*/

  function vBasis( p1, p2 ) {
    var v1 = diff( p2, p1 ); 
    vNormSelf( v1 );
    var v2;
    if (Math.abs(v1[0]) < 0.0000001)
      v2 = [ 0, -v1[2], v1[1] ];
    else
      v2 = [ -v1[1], v1[0], 0 ];
    vNormSelf( v2 );

    v3 = crossProduct( v1, v2 );
    return [ v1, v2, v3 ];
  }

  // use this? https://github.com/toji/gl-matrix/blob/master/src/gl-matrix/vec3.js

  function vLerp (a, b, t) {
    var ax = a[0],
        ay = a[1],
        az = a[2];
    var out = [0,0,0];
    out[0] = ax + t * (b[0] - ax);
    out[1] = ay + t * (b[1] - ay);
    out[2] = az + t * (b[2] - az);
    return out;
  };

    ////////////////////////////////////////////////////////////////////////////////////

    function setGuiProgress( percent,message ) {
      if (percent < 0) {
        jQuery( "#guiProgress").hide();
        return;
      }
      jQuery( "#guiProgress").show();
      jQuery( "#guiProgressValue").width( Math.round(percent) + "%" );
    }

    
    var commonLoadingFilesHash = {};
    function setFileProgress( filename, msg, percent, callback )
    {
      var hsh = commonLoadingFilesHash;
    
      if (!msg) {
        delete hsh[ filename ];
        setGuiProgress( -1 );
      }
      else {
        hsh[ filename ] = msg + (percent >= 0 ? " " + (percent.toFixed ? percent.toFixed(2) : percent) +"%" : "");

        if (typeof(percent)==="number") {
          setGuiProgress( percent );
          if (percent < 0) {
             setTimeout( function() {
                setFileProgress( filename );
             }, 15000 );
          }
        }
      }

      var acc = [];
      for (var i in hsh) {
       acc.push( i + " " + hsh[i] );
      }
      // красивая раскраска красненьким
      acc = acc.map( function(str) {
        if (str.match(/error/i)) {
          return "<span class='la_error'>"+str+"</span>";
        } else return str;
      } );
       
      jQuery( "#fileProgress" ).html( acc.join("<br/>") );

      if (callback) 
         setTimeout( function (){ callback() }, 50 );
    }
    
    /* mv to scene.html
    function initFileProgress() {
      jQuery( window ).load(function() {
        jQuery( "body" ).append( "<div id='fileProgress' style='position:fixed; bottom: 2px; right: 84px; padding: 2px; background-color: #070; color: #fff'>12345<br/>777</div>");
      });
    }
    
    initFileProgress();
    */

//////////////////////////////////////////////////////////////////////
la_require_write("files.js");

//////////////////////////////////////////////////////////////////////
    
/// работа с цветом    
// c число от 0 до 255
function componentToHex(c) {
    if (typeof(c) === "undefined") {
      debugger;
    }
    var hex = c.toString(16);
    return hex.length == 1 ? "0" + hex : hex;
}

// r g b от 0 до 255
function rgbToHex(r, g, b) {
    return "#" + componentToHex(r) + componentToHex(g) + componentToHex(b);
}  

// triarr массив из трех чисел 0..1
function tri2hex( triarr ) {
   return rgbToHex( Math.floor(triarr[0]*255),Math.floor(triarr[1]*255),Math.floor(triarr[2]*255) )
}

// triarr массив из трех чисел 0..1
function color2css( triarr ) {
   if (typeof(triarr) === "string") return triarr;
   return tri2hex( triarr );
}

// triarr массив из трех чисел 0..1 - выход число int
function tri2int( triarr ) {
   return Math.floor(triarr[0]*255) * (256*256) + Math.floor(triarr[1]*255)*256  + Math.floor(triarr[2]*255);
}

function int2tri( col ) {
  return [ ((col >> 16) & 255) / 255.0, ((col >> 8) & 255)/ 255.0, (col & 255)/ 255.0 ];
}

function any2tri( col ) {
  if (Array.isArray(col))  // already arr
    return col;
  if (typeof(col) == "string") // hex
    return hex2tri( col );
    
  return int2tri( col );  // assume int
}

// hex запись в массив 3 чисел 0..1
function hex2tri(hex) {
    var result = /^#?([a-f\d]{2})([a-f\d]{2})([a-f\d]{2})$/i.exec(hex);
    return result ? [
        parseInt(result[1], 16) / 255.0,
        parseInt(result[2], 16) / 255.0,
        parseInt(result[3], 16) / 255.0
    ] : [1,1,1];
}

  function isnan(v) {
    if (v === null) return true;
    if (v === "") return true;
    return isNaN(v);
  }
  


//////////////////////////////////////////////////////////////////////

  // http://habrahabr.ru/post/250885/#comment_8294577
  function translit(text) {
            return text.replace(/([а-яё])|([\s_-])|([^a-z\d])/gi,
                function (all, ch, space, words, i) {
                    if (space || words) {
                        return space ? '-' : '';
                    }
                    var code = ch.charCodeAt(0),
                        index = code == 1025 || code == 1105 ? 0 :
                            code > 1071 ? code - 1071 : code - 1039,
                        t = ['yo', 'a', 'b', 'v', 'g', 'd', 'e', 'zh',
                            'z', 'i', 'y', 'k', 'l', 'm', 'n', 'o', 'p',
                            'r', 's', 't', 'u', 'f', 'h', 'c', 'ch', 'sh',
                            'shch', '', 'y', '', 'e', 'yu', 'ya'
                        ];
                    return t[index];
                });
        }

///////////////////////////////
window.some_global_counter = 0;

function getGlobalCounter() {
  window.some_global_counter = window.some_global_counter+1;  
  return window.some_global_counter;
}
///////////////////////////////

function flattenArrayOfArrays(a, r){
    if (!r) { r = [] }
    if (!a) return [];
    if (a.constructor !== Array) return [a];
    for(var i=0; i<a.length; i++){
        if (typeof(a[i]) === "undefined") continue;

        if(a[i].constructor == Array){
            flattenArrayOfArrays(a[i], r);
        }else{
            r.push( a[i] );
        }
    }
    return r;
}
////////////////////////////////////
function findScene(someobj)
{
    var f = someobj;
    //console.log(1);
    while (f) {
      if (f.findRootSpace) break;
      f = f.parent;
    }
    return f;
}

function findRootScene(someobj) {
  someobj = findScene(someobj);
  if (someobj && someobj.findRootSpace)
    return someobj.findRootSpace();
  return null;
}