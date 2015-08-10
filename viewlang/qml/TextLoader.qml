Item {
    property var file    // входной файл
    property var output  // загруженные данные
    property bool enabled: true

    signal loaded( string loadedFile, string loadedOutput );
    
    property var q: {
      if (!file || !enabled) {
        output = "";
        return;
      }
      var f = file;
      loadFile( f, function(res) {
        output = res;
        loaded( f,res );
      }, function (err) {
        var res = "";
        output = res;
        loaded( f,res );
      } ); 
    } 

}
