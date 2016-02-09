//<!-- Styler embed script -->

// thanx to http://stackoverflow.com/a/2161748/657240
// our task is: determine path current script (run_styler.js) so we can generate pathes to images, css, etc
var scripts= document.getElementsByTagName('script');

var path_parts = ["",""];
for (var i=0; i<scripts.length; i++)
  if ( scripts[i].src.indexOf("run_styler.js") > 0)
    path_parts = scripts[i].src.split('?');

var path = path_parts[0];      // remove any ?query
var styler_query_string = path_parts.length > 1 ? path_parts[1] : "";
var styler_basepath = path.split('/').slice(0, -1).join('/')+'/';  // remove last filename part of path

function styler_params(name){
    var results = new RegExp('[\\?&]' + name + '=([^&#]*)').exec("?"+styler_query_string);
    if (!results) { return 0; }
    return results[1] || 0;
}

function styler_file(name) { return name + "?v081112"; }

var debug = styler_params("debug") != 0;            //styler_query_string.indexOf("debug") >= 0;
var styler_en = styler_params("lang") == "en";      //styler_query_string.indexOf("english") >= 0;

var jquery171    = debug?styler_basepath+'jquery/jquery.js':'http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js';
var jqueryui1821 = debug?styler_basepath+'jquery/jquery-ui.js':'http://ajax.googleapis.com/ajax/libs/jqueryui/1.8.21/jquery-ui.min.js';

document.write('<link href="' + styler_basepath + 'styler/' + styler_file("styler.css")+'" type="text/css" rel="stylesheet">');

document.write('<script type="text/javascript" src="'+jquery171+'"></script>');
document.write('<script type="text/javascript"> jQuery.noConflict(); </script>');
document.write('<script type="text/javascript" src="'+jqueryui1821+'"></script>');

// i18n
if (styler_en)
  document.write('<script src="' + styler_basepath + styler_file("world_en.js") + '"></script>');
else
  document.write('<script src="' + styler_basepath + styler_file("world_ru.js") + '"></script>');

//document.write('<script src="' + styler_basepath + 'jquery/jquery.i18n.properties-1.0.9.js"></script>');
//document.write('<script type="text/javascript"> jQuery.i18n.properties({ name: "messages", language: "ru" });</script>');

document.write('<script src="' + styler_basepath + 'jquery/jquery.textchange.min.js"></script>');
//document.write('<script src="' + styler_basepath + 'jquery/jquery.autosize-min.js"></script>');
document.write('<script src="' + styler_basepath + styler_file("selectors.js") + '"></script>');

document.write('<script src="' + styler_basepath + styler_file("styler.js") +"&"+ styler_query_string + '"></script>');

document.write('<link rel="stylesheet" media="screen" type="text/css" href="' + styler_basepath + 'colorpicker/css/colorpicker.css" />');
document.write('<script type="text/javascript" src="' + styler_basepath + 'colorpicker/js/colorpicker.js"></script>');

//4pro:
//document.write('<script src="' + styler_basepath + 'jquery/jquery.js"></script>');
//document.write('<script src="' + styler_basepath + 'jquery/jquery-ui.js"></script>');
//document.write('<script src="http://yandex.st/jquery/1.7.2/jquery.min.js"></script>');
//document.write('<script src="http://yandex.st/jquery-ui/1.8.21/jquery-ui.min.js"></script>');

// IE fix, see http://stackoverflow.com/a/10484509/657240
// document.write( "<!--[if IE 8]><script>\ndocument.getElementsByClassName = \nElement.prototype.getElementsByClassName = function(class_name) {\n    // Escape special characters\n    class_name = (class_name + ').replace(/[~!@$%^&*()_+-=,./';:\"?><[]{}|`#]/g, '\\$&');\n    return this.querySelectorAll('.' + class_name);\n};\n</script><![endif]-->" );
