// Это отркрывает коннект и принимает

Item {

  property bool enabled: false

  property  var oscPort

  Component.onCompleted: runosc()
  onEnabledChanged: runosc();
  
  property var oscUrl: Qt.resolvedUrl("test").indexOf(":/") >= 0 ? "ws://localhost:8081" : "ws://viewlang.ru:8081"

  function runosc() {
    if (!enabled) return;
    if (oscPort) {
      try {
        oscPort.close();
      } catch(err) 
      { 
      }
    }
    
    la_require( "../qml/osc-browser.min.js", function() {
            if (!enabled) return;

            console.log("openging socket to oscUrl=",oscUrl);
            
            oscPort = new osc.WebSocketPort({
                url: oscUrl
            });
            
            oscPort.on("message", function (oscMessage) {
                var paramname = oscMessage.address.split( "/param/" ) [1];
                console.log("so got message", oscMessage,paramname);

                var params = sceneObj.rootScene.gatheredParams;
                var value =  oscMessage.args[0];

                /* вроде это уже не надо
                var value_seconds = oscMessage.args[1] || 0;
                
                var seconds = new Date().getTime() / 1000; 
                console.log(value,value_seconds,seconds);
                if (value_seconds !== 0 || value_seconds < seconds) return;
                console.log("passed, gonna set");
                */
                for (var i=0; i<params.length; i++)
                  if (params[i].name == paramname) {
                    console.log("setting ",value,"to",params[i].propertyWrite);
                    params[i].nowWriting = true;
                    params[i].target[ params[i].propertyWrite ] = value;
                    params[i].nowWriting = false;
                  }
            });
            
            try {
              oscPort.open();
            } catch(err) {
              console.error(err);
              oscPort = null;

            }
    
    });  
  
  }
}