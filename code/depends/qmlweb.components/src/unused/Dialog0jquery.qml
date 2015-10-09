Item {
  id: dlg

  property var jdialog
  
  dom.width: 405
  css.width: 405
  clip:false
  
  Component.onCompleted: {
    la_require( "jquery-ui/jquery-ui.css", function() {
      la_require( "jquery-ui/jquery-ui.min.js", function() {
        dlg.dom.width = 400;
        jdialog = jQuery(dlg.dom);
        jQuery( jdialog ).dialog({
          autoOpen: false,
          width: 400,
          height: 300
        });
        

        
        //dlg.implicitWidth = jdialog.dialog( "option", "width" );
        //dlg.implicitHeight = jdialog.dialog( "option", "height" );
        //debugger;

      } );
    });
  }

  function open() {
    jdialog.dialog('open');
  }

  function close() {
    jdialog.dialog('close');
  }  

  ///////////////////////// internal
  
  property var jdir: Qt.resolvedUrl("");
  function la_path(file) { return jdir+file; }

  function la_require(file,callback){
    if (!window.la_required) window.la_required = {}

    console.log("la_required[file]=",la_required[file],"file=",file);
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
  
}