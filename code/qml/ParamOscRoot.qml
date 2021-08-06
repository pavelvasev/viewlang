// Это отркрывает коннект и принимает

Item {

  property bool enabled: false

  property  var oscPort

  Component.onCompleted: runosc()
  onEnabledChanged: runosc();
  
  property var oscUrl: Qt.resolvedUrl("test").indexOf("file:/") >= 0 ? "ws://localhost:8081" : "ws://viewlang.ru:8081"
  
  property var gatheredParams: qmlEngine.rootObject.gatheredParams || []

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
                // не мудрствуем.. var paramname = oscMessage.address.split( "/param/" ) [1];
                var paramname = oscMessage.address;
                // console.log("so got message", oscMessage, paramname);

                var params = gatheredParams;
                var value =  oscMessage.args.length == 1 ? oscMessage.args[0] : oscMessage.args;

                /* вроде это уже не надо
                var value_seconds = oscMessage.args[1] || 0;
                
                var seconds = new Date().getTime() / 1000; 
                console.log(value,value_seconds,seconds);
                if (value_seconds !== 0 || value_seconds < seconds) return;
                console.log("passed, gonna set");
                */
                for (var i=0; i<params.length; i++) {
                  //console.log( "params[i].nameWithSlash = ",params[i].nameWithSlash);
                  if (params[i].nameWithSlash == paramname) {
                    //console.log("setting ",value,"to",params[i].propertyWrite, "target=",params[i].target.id);
                    params[i].nowWriting = true;
                    params[i].target[ params[i].propertyWrite ] = value;
                    params[i].nowWriting = false;
                    // хм пусть все параметры break;
                  }
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