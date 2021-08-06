// Регистрирует себя в rootScene.gatheredParams
/* TODO сделать отдельный робот, цель которого - зарегать родителя в заданных списках
   а то все смешалось, кони люди..
*/

Item {
  id: obj
  
  property var target: parent
  property var property: "value"
  property var propertyWrite: property
  property var name
  property var text
  property bool nowWriting: false

  property var enabled: true
  property var nameWithSlash: name && name.length > 0 ? (name[0] == "/" ? name : "/" + name) : "";
  
  Component.onCompleted: tryreg()
  
  onNameChanged: tryreg();
  
  property bool registered: false
  
  property var gatheredParams: qmlEngine.rootObject.gatheredParams || []
  
  function tryreg()
  {
     if (registered) return;
     //console.log("ParamAnimation: trying to register.",name,target.text);
     
     if (enabled && target && name && target.text) {

       if (target.animationPriority)
         gatheredParams.unshift( obj );
       else
         gatheredParams.push( obj );

       obj.Component.destruction.connect( removeObjFromCount );
       registered=true;
       // console.log("registered");
     }
     //else
     //  console.log("not registered");
  }

  function removeObjFromCount() {
    var idx = gatheredParams.indexOf(obj);
    if (idx >= 0) gatheredParams.splice( idx, 1 );
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