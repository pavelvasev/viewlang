//<!-- Styler embed script -->

// thanx to http://stackoverflow.com/a/2161748/657240
// our task is: determine path current script (run_styler.js) so we can generate pathes to images, css, etc
var scripts= document.getElementsByTagName('script');

var path_parts = ["",""];

for (var i=0; i<scripts.length; i++)
  if ( scripts[i].src.indexOf("run_viewlang.js") > 0)
    path_parts = scripts[i].src.split('?');

var path = path_parts[0];      // remove any ?query
console.log(">>>>>>>>>> path=",path_parts );
var styler_query_string = path_parts.length > 1 ? path_parts[1] : "";
var styler_basepath = path.split('/').slice(0, -2).join('/')+'/';  // remove last filename part of path

function styler_params(name){
    var results = new RegExp('[\\?&]' + name + '=([^&#]*)').exec("?"+styler_query_string);
    if (!results) { return 0; }
    return results[1] || 0;
}

function styler_file(name) { return name + "?v081112"; }

window.addEventListener('load', function() {
for (var i=0; i<scripts.length; i++) {
  if ( scripts[i].type.indexOf("viewlang") > 0) {
    var scripta = scripts[i];
    console.log( "hi scene!",scripts[i] );

     var el = document.createElement("iframe");
     document.body.appendChild(el);
     el.id = 'viewlang_show';
     el.style.width = "100%";
     el.style.height = "97vh";
     el.style.border = "0";
     el.src = styler_basepath + "scene.html?s=message";

     code = scripta.text;
     if (code.indexOf("Scene") < 0) code = "Scene {\n" + code + "\n}"

     console.log( "code=",code);

     el.addEventListener('load', function(event) {
      // https://viget.com/extend/using-javascript-postmessage-to-talk-to-iframes
      console.log("myframe is loaded - sensing message");
      event.target.contentWindow.postMessage( {cmd:"useCode",args:[code]},"*");
    });

  }
}

});

/* TODO
  может не скрипт, а тег
  стили включения настройка пользователем
  несколько сцен на странице
  загружать некое src а не содержимое..
*/