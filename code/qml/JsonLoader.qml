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
        output = parseJson( res );
        ldr.xhr = null;
        //console.log("json output=",output);
      }, function(err) {
        ldr.xhr = null;
      } ); 
    } 

}
