// Kees some object property value in browser url hash
Item {
  id: obj
  
  property var target: parent
  property var property: "value"
  property var propertyWrite: property
  property var name                       // url hash item name

  property var timeout: 250               // milliseconds

  property var enabled: true

  property var paramName: name

 /* 
  onValueChanged: {
    //console.log(paramName,value);
    //params_update_hash();
  }
 */

  property var timeout_id 

  function params_update_hash()
  {
     
     if (!paramName || paramName.length == 0) return;
     if (engine.operationState === QMLOperationState.Init) return;
     //debugger;
     // нее if (timeout_id) return;
     if (timeout_id) window.clearTimeout( timeout_id );

     timeout_id = window.setTimeout( function() {

     var oo = {};
     if (location.hash.length >= 10) 
        oo = read_hash_obj();

     if (!oo.params) oo.params = {};

     if (obj.enabled) {
 	   var value = target[property];     
       oo.params[paramName] = value;
     }
     else
      delete oo.params[paramName]

     var strpos = JSON.stringify( oo ); 
     //console.log(">>>> setting url hash from param",paramName,value);

     if (strpos == "{\"params\":{}}") {
       strpos = "";
     }
     if (location.hash != strpos);
       location.hash = strpos;
     timeout_id = null;

     }, timeout );
  }  

  function read_hash_obj() {
      var oo = {};
       try {
         oo = JSON.parse( location.hash.substr(1) );
       } catch(err) {
         // sometimes url may be converted. decode it.
         try {
           oo = JSON.parse( decodeURIComponent( location.hash.substr(1) ) );
         }
         catch (err2) {
           // do nothing
         }
       }
     return oo;
  }
  
  function params_parse_hash()
  {
//    console.log( "params_parse_hash name=",paramName);
    if (!paramName || paramName.length == 0) return;
    if (location.hash.length < 10) return {};
    var oo = read_hash_obj();
    // var oo = JSON.parse( location.hash.substr(1) );
    if (oo.params == null) return {};
    if (oo.params.hasOwnProperty(paramName)) {
//      console.log(">>>setting param from url-hash",paramName,oo.params[paramName]);
      target[propertyWrite] = oo.params[paramName]; 
    }
  }
  

  Component.onCompleted: {
    params_parse_hash()
    target[property+"Changed"].connect( obj,params_update_hash );
    inited = true;
  }
  property bool inited: false  
  
  onNameChanged: {
//    console.log("^^^^^^^^^^ nrew name=",paramName);
    // это на тот случай, когда имя параметра внезапно меняется, после изменения какого-то scopeName,
    // например при динамической загрузке приложения как в distort/appender
    if (inited)
      params_parse_hash();
  }
  
  onEnabledChanged: {
    if (inited) {
      params_update_hash();
    }
  }
  
}