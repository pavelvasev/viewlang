// Kees some object property value in browser url hash
// todo https://developer.mozilla.org/en-US/docs/Web/API/History_API

// todo: manual, enabled - clarify its logic
Item {
  id: obj
  
  property var target: parent
  property var property: "value"
  property var propertyWrite: property
  property var name                       // url hash item name

  property var timeout: 250               // milliseconds

  property var enabled: true

  property var paramName: name

  property var timeout_id 

  property bool manual: false
  
  /////
  property var stateManager: qmlEngine.rootObject.stateManager || qmlEngine.rootObject
  // объект менеджера состояния может поддерживать методы: getState->{} + patchState( {} ), а также сигнал sendStateToParams
  
  // обновляет значение параметра из объекта состояния
  function getFromState() {
    if (stateManager && stateManager.getState) {
      doRefreshParams( stateManager.getState() );
    }
    else
      params_parse_hash();
  }
  
  // записывает значение параметра в объект состояния
  function putToState() {
    if (stateManager && stateManager.patchState) {
      var value = obj.enabled ? target[property] : undefined;
      var patch = {};
      patch[ paramName ] = value;
      stateManager.patchState( patch,"ParamUrlHashing/"+paramName )
    }
    else
      params_update_hash();
  }
  
  /////
  
  function overwriteParamsInHash(params) {
     var strpos = JSON.stringify( { "params" : params } );

     if (strpos == "{\"params\":{}}") {
       strpos = "";
     }

     //strpos = encodeURIComponent( strpos );
     strpos = strpos.replace(/ /g, "%20");

     //if (location.hash != strpos);
     location.hash = strpos;
  }

  function params_update_hash()
  {

     if (!paramName || paramName.length == 0 || !property) return;
     if (engine.operationState === QMLOperationState.Init) return;

     // нее if (timeout_id) return;
     if (timeout_id) { window.clearTimeout( timeout_id ); timeout_id = null; }

     var perform = function() {

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

     if (strpos == "{\"params\":{}}") {
       strpos = "";
     }

     //strpos = encodeURIComponent( strpos );
     strpos = strpos.replace(/ /g, "%20");

     if (location.hash != strpos);
       location.hash = strpos;
 
     timeout_id = null;

     };

     if (timeout > 0) timeout_id = window.setTimeout( perform, timeout ); else perform();
  }

  function read_hash_obj() {
      var oo = {};
       try {
         var s = location.hash.substr(1);
         // we have 2 variations: use decode and use replace %20.
         // at 2020 we see Russian language in objects, thus we use variant with decode.
         s = decodeURIComponent( s );
         //s = s.replace(/%20/g, " ");
         oo = JSON.parse( s );
       } catch(err) {
         // sometimes url may be converted. decode it.
         try {
           //oo = JSON.parse( decodeURIComponent( location.hash.substr(1) ) );
           // если не получилось с decode - попробуем без него
           oo = JSON.parse( location.hash.substr(1) );
         }
         catch (err2) {
           // do nothing
         }
       }
     return oo;
  }
  
  function params_parse_hash()
  {
    if (!paramName || paramName.length == 0 || !propertyWrite) return;
    if (location.hash.length < 10) return {};

    var oo = read_hash_obj();

    if (oo.params == null) return {};
    if (oo.params.hasOwnProperty(paramName)) {
        //console.log("rww propertyWrite=",propertyWrite,"oo.params[paramName]=",oo.params[paramName]);
        target[propertyWrite] = oo.params[paramName]; 
    }
  }

  Component.onCompleted: {
    getFromState();
    //params_parse_hash();
    
    if (!manual && property) {
      
    
      target[property+"Changed"].connect( obj,putToState );
      
      // sendStateToParams это сигнал объекта состояния
      if (stateManager && stateManager.sendStateToParams )
          stateManager.sendStateToParams.connect( obj, doRefreshParams );
      // это какие-то устаревшие протоколы
      if (stateManager && stateManager.windowHashToParams)
          stateManager.windowHashToParams.connect( obj, doWindowHashToParams );

      /*
      window.addEventListener('popstate', function(e){
        params_parse_hash();
      }, false);
      */
    }
    inited = true;
  }
  property bool inited: false  
  
  onParamNameChanged: {
    // console.log("^^^^^^^^^^ nrew name=",paramName);
    // это на тот случай, когда имя параметра внезапно меняется, после изменения какого-то scopeName,
    // например при динамической загрузке приложения как в distort/appender
    if (inited)
      getFromState();
      //params_parse_hash();
  }
  
  onEnabledChanged: {
    if (inited) {
      putToState();
      //params_update_hash();
    }
  }
  
  // устанавливает значение параметра себе из словаря
  function doRefreshParams(params) {
    if (!paramName || paramName.length == 0 || !propertyWrite) return;
    if (!enabled) return;
    // enabled?
    //console.log("do refresh state",paramName);
    if (params.hasOwnProperty(paramName)) {
        //console.log("writing to target");
        target[propertyWrite] = params[paramName];
    }
  }
  
  // сигнал для принудительного обновления из хеша
  function doWindowHashToParams() {
    // console.log("parameter windowHashToParams",name );
    params_parse_hash();
  }

}