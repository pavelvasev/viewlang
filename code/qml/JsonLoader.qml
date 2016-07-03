Item {
    id: ldr

    property var file    // входной файл
    property var output  // загруженные данные
    property var enabled: true

    property var q: {
      if (ldr.xhr) ldr.xhr.abort();
      ldr.xhr = null;

      if (!file || !enabled) {
        output = [];
        return;
      }

      ldr.xhr = loadFile( file, function(res) {
        try {
          output = JSON.parse( res );
        } catch(err) {
          console.error("JsonLoader: json parse error. file=",file );
          console.error(err);
          failed();
        }
        ldr.xhr = null;
        //console.log("json output=",output);
      }, function(err) {
        ldr.xhr = null;
        failed();
      } ); 
    }

    signal failed();
}
