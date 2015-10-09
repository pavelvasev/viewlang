Item {
  id: obj
  
  property var target: parent
  property var property: "value"
  property var propertyWrite: property
  property var name
  property var text
  property bool nowWriting: false

  property var enabled: true
  
  Component.onCompleted: {
     if (enabled && target && name && target.text) {
       var rootScene = findRootScene(obj);
       rootScene.gatheredParams.push( obj );
       rootScene.gatheredParamsChanged();

       obj.Component.destruction.connect( removeObjFromCount );
     }
  }

  function removeObjFromCount() {
    var rootScene = findRootScene(obj);
    var idx = rootScene.gatheredParams.indexOf(obj);
    if (idx >= 0) rootScene.gatheredParams.splice( idx, 1 );
  }       
  

  // osc
  ParamOsc {
    target: obj.target
    property: obj.property
    propertyWrite: obj.propertyWrite
    nowWriting: obj.nowWriting
    name: obj.name    
  }

}