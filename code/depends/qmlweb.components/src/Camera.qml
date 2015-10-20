Video {
  id: camera
  autoPlay : true
  controls: false
  width: 640
  height: 480
  fillMode: VideoOutput.PreserveAspectFit

  property bool active: true

  Component.onCompleted: {
    //activate();
    activeChanged();
  }

  onActiveChanged: {
    if (active) activate(); else deactivate();
  }

  function deactivate() {
    camera.source = "";
  }
  
  function activate() {

      function callGetUserMedia( a,b,c ) {
        if (navigator.getUserMedia) navigator.getUserMedia( a,b,c );
        else
        if (navigator.webkitGetUserMedia) navigator.webkitGetUserMedia( a,b,c );
        else
        if (navigator.mozGetUserMedia) navigator.mozGetUserMedia( a,b,c );
        else
        if (navigator.msGetUserMedia) navigator.msGetUserMedia( a,b,c );
        else
          return false;
        return true;
      }
      
      var hasmedia = !!(navigator.getUserMedia || navigator.webkitGetUserMedia || navigator.mozGetUserMedia || navigator.msGetUserMedia);

      callGetUserMedia({video:true, audio:false},
          function(stream) {
            camera.source =  URL.createObjectURL(stream);
          }, function (error) {
            console.log("Camera error",error);          
          } 
      );
  
  }
}