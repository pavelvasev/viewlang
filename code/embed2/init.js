// import "../depends/lazy/lazy.js";
// import "../depends/lazy/lazy.browser.js";
// import "../depends/papaparse/papaparse.js";
// import "../base.js";
// import "../threejs_driver/init.js";

// вот он тут уже кидается создавать dom-элементы для рендеринга

/////////////////////////////////////////

export function create_qmlweb( dom ) {
  var qmlEngine = new QMLEngine(q);
  // window.qmlEngine = qmlEngine; /// временно так, т.к. есть несколько опор на ето
  // пусть вовне стараюстя
  return qmlEngine;
}

export function setup_qmlweb( qmlEngine ) {
  setupQmlwebPathsForViewlang( qmlEngine );

  var ostart = qmlEngine.start;
  qmlEngine.start = function() {
    ostart.apply( qmlEngine );
    startScene(); // запуск гр драйвера
    reval();
  };
  
  // if (errorToReport) qmlEngine.rootObject.info = errorToReport;
  setGuiProgress( -1 );

  // управление qml-параметрами width/height в зависимости от того что там накрутил пользователь окном
  function reval() {
    var dom = qmlEngine.rootElement;
    jQuery( dom ).height( jQuery(window).height() - jQuery("#infoDark").height()-10 );
    dom.updateQmlGeometry();
    //console.log("setted",jQuery(q).height(), q.offsetHeight);
  }
  window.addEventListener("resize",reval );
  
  window.loadedSourceFile="";
}

export function setupQmlwebPathsForViewlang( qmlEngine ) {
  // todo: check if called once...
  
  var viewlangDir = (new URL("../", import.meta.url )).toString();

  qmlEngine.addImportPath( viewlangDir + "" );

  qmlEngine.addModulePath( "components.appmix",viewlangDir + "components/appmix" );
  qmlEngine.addModulePath( "components.csv_loader",viewlangDir + "components/csv_loader" );
  qmlEngine.addModulePath( "components.show_points",viewlangDir + "components/show_points" );

  // 1. specify module path's
  qmlEngine.addModulePath( "viewlang",viewlangDir );
  qmlEngine.addModulePath( "qmlweb.components",viewlangDir + "depends/qmlweb.components/" );
  qmlEngine.addModulePath( "QtQuick.Controls",viewlangDir + "depends/qmlweb.components/" ); // make it synomym to qmlweb.components
  // 2. autoload modules. use little hack for this.
  var parseQMLold = parseQML;
  // ну вот это пипец
  parseQML = function (src, file) {
    var src2 = src ? "import viewlang 1.0\nimport qmlweb.components 1.0\n" + src : src;
    return parseQMLold(src2, file);
  }

}

export function setup_driver( driver_path ) {
  la_require_prefix = driver_path;
  la_require_write("init.js");
}

