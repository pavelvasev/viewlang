// Это посылает

Item {
  id: obj
  
  property var target: parent
  property var property: "value"
  property var propertyWrite: property
  property var name
  property bool nowWriting: false

  property var nameWithSlash: name && name.length > 0 ? (name[0] == "/" ? name : "/" + name) : "";
  
  property var oscManager: qmlEngine.rootObject.oscManager || qmlEngine.rootObject;

  function param_changed()
  {
     if (!name || name.length == 0) return;
     if (engine.operationState === QMLOperationState.Init) return;
     if (nowWriting) return;

     var value = target[property];
     
     var port = oscManager.oscPort;
     if (!port) return;
     
     // console.log("sending",name,value);
     // http://stackoverflow.com/a/3830279/657240
     // var seconds = new Date().getTime() / 1000; 
     var nameWithSlash = name[0] == "/" ? name : "/" + name;
     
     port.send({
                    address: nameWithSlash, // типа а зачем мы мудрствуем... как пришло так пусть и ходит address: "/param/"+name,
                    args: value
                    //args: [value,seconds]
     });
   
     return;
  }  

  Component.onCompleted: {
    target[property+"Changed"].connect( obj,param_changed );
  }
  
}