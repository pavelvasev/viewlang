// Это посылает

Item {
  id: obj
  
  property var target: parent
  property var property: "value"
  property var propertyWrite: property
  property var name
  property bool nowWriting: false

  function param_changed()
  {
     if (!name || name.length == 0) return;
     if (engine.operationState === QMLOperationState.Init) return;
     if (nowWriting) return;

     var value = target[property];
     
     var rootScene = findRootScene(obj);
     var port = rootScene.oscManager.oscPort;

     if (!port) return;
     
     // console.log("sending",name,value);
     // http://stackoverflow.com/a/3830279/657240
     // var seconds = new Date().getTime() / 1000; 
     port.send({
                    address: "/param/"+name,
                    args: value
                    //args: [value,seconds]
     });
   
     return;
  }  

  Component.onCompleted: {
    target[property+"Changed"].connect( obj,param_changed );
  }
  
}