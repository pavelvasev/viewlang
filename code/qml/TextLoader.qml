Item {
    property var file    // входной файл
    property var output  // загруженные данные
    property bool enabled: true
    property bool loading: false

    signal loaded( string loadedFile, string loadedOutput );
    
    property var q: {
      if (!file || !enabled) {
        output = "";
        return;
      }
      var f = file;
      loading = true;
      loadFile( f, function(res) {
        output = res;
        loading = false;
        loaded( f,res );
      }, function (err) {

        var res = "";
        // console.log(err);
        output = res;
        loading = false;
        loaded( f,res );

      } ); 
    } 

}
