// собственно добавлены вызовы file_on/off
// надо бы это перетащить в какую-то фичу

////////////////////// feature
// flag that data is loading
// this is used to pause animation

function file_on() {
  setTimeout( function() {
  qmlEngine.rootObject.propertyComputationPending = qmlEngine.rootObject.propertyComputationPending+1;
  }, 0);
}
function file_off() {
  setTimeout( function() {
  qmlEngine.rootObject.propertyComputationPending = qmlEngine.rootObject.propertyComputationPending-1;
  }, 0);
}

/////////////////////// file io
    
function loadFile( file_or_path, handler, errhandler ) {
    return loadFileBase( Qt.resolvedUrl(file_or_path), true, handler, errhandler );
}
function loadFileBinary( file_or_path, handler, errhandler ) {
    return loadFileBase( Qt.resolvedUrl(file_or_path), false, handler, errhandler );
}

function loadFileBase( file_or_path, istext, handler, errhandler ) {
    if (file_or_path instanceof File) {
        // http://www.html5rocks.com/en/tutorials/file/dndfiles/
        setFileProgress( file_or_path.name,"loading");
        file_on();

        var reader = new FileReader();

        window.setTimeout( function() {

            reader.onload = function () {
                //console.log(reader.result);
                setFileProgress( file_or_path.name,"parsing");
                window.setTimeout( function() {
                    try {
                      handler( reader.result, file_or_path.name );
                    } catch (err) {
                      console.error(err);
                      setFileProgress( file_or_path,"PARSE ERROR");
                      if (errhandler) errhandler(err,file_or_path);
                      file_off();
                      return;
                    }
                    setFileProgress( file_or_path.name );
                    file_off();
                },5 );

            };

            if (istext)
                reader.readAsText( file_or_path );
            else
                reader.readAsArrayBuffer( file_or_path );

        }, 5); //window.setTimeout

        var result = {};
        result.abort = function() { reader.abort(); setFileProgress( file_or_path.name ); file_off(); }
        result.stoploading = function() { reader.abort(); setFileProgress( file_or_path.name ); file_off(); }
        return result;
    }
    else
    {
        if (file_or_path && file_or_path.content) {
          handler( file_or_path.content, "data" );
          return;
        }
        
        var payload;
        if (file_or_path && file_or_path.path) {
          payload = file_or_path.payload;
          file_or_path = file_or_path.path;
        }
        
        if (file_or_path && file_or_path.length > 0) {
            if (file_or_path.match(/^wss?:\/\//))
              return loadFileWebsocket( file_or_path, istext, handler, errhandler );
        
            setFileProgress( file_or_path,"loading");
            file_on();

            var xhr = new XMLHttpRequest();
            //xhr.open('GET', file_or_path, true);
            // нет слов.. чтобы работало payload, надо слать с post
            xhr.open( payload ? 'POST' : 'GET', file_or_path, true);
            xhr.responseType = istext ? 'text' : 'arraybuffer';
            // тоже нет слов.. это чтобы оно хотя бы с etag консультировалось
            //xhr.setRequestHeader("Cache-Control", "no-cache");

            xhr.onload = function(e) {
                //console.log("xhr loadFileBase onload fired",file_or_path,e);
                //console.log("this=",this);
                // response is unsigned 8 bit integer
                //var responseArray = new Uint8Array(this.response);
                setFileProgress( file_or_path,"parsing");
                file_off();
                handler( this.response, file_or_path );
                
                /* тяжело отлаживаться получается
                try {
                  handler( this.response, file_or_path );
                } catch (err) {
                  console.error(err);
                  setFileProgress( file_or_path,"PARSE ERROR");
                  if (errhandler) errhandler(err,file_or_path);
                  //throw err;
                  return;
                }*/

//setFileProgress( file_or_path );

                var iserr = this.status == 404 || !this.response;
                if (!iserr) {
                  setFileProgress( file_or_path, "loaded" );
                  setTimeout( function() {
                    setFileProgress( file_or_path );
                  }, 500 ); // не сразу убирать сообщение
                } else {
                  console.log("xhr load error (soft)");
                  console.log("xhr object=",this);
                  console.log("event=",e);
                  setFileProgress( file_or_path, "RESPONSE ERROR" );
                  setTimeout( function() {
                    setFileProgress( file_or_path );
                  }, 25000 ); // не сразу убирать сообщение                
                }
                
            };

            xhr.onerror = function(e) {
                file_off();
                setFileProgress( file_or_path,"AJAX READ ERROR");
                setTimeout( function() {
                    setFileProgress( file_or_path );
                }, 25000 );
                console.log("xhr error. file_or_path=",file_or_path);
                if (errhandler) errhandler(e,file_or_path); // но вообще это спорно, то что мы передаем вторым параметром урль..
            }
            
            if (payload) {
              console.log("SENDING PAYLOAD",payload);
//              debugger;
              xhr.setRequestHeader("Content-Type", "application/json");
              xhr.send( payload );
            }
            else
              xhr.send();

            var result = {};
            result.abort = function() { xhr.abort(); setFileProgress( file_or_path ); file_off(); }
            result.stoploading = function() { xhr.abort(); setFileProgress( file_or_path ); file_off(); }
            return result;

                /* ранее вызывали по jquery так. но еще нужен был для arraybuffer
               https://github.com/henrya/js-jquery/blob/master/BinaryTransport/jquery.binarytransport.js
            // https://api.jquery.com/jquery.get/
            var jqxhr = jQuery.get( file_or_path, function(data) {
                setFileProgress( file_or_path,"parsing");
                handler(data);
                setFileProgress( file_or_path );
            }, istext ? "text" : "binary" );
            // надо указать явно datatype text, а то если будет json-файл то его нам уже пропарсят, что неожиданно для нас.
            jqxhr.fail(function() {
                setFileProgress( file_or_path,"AJAX READ ERROR",-5000 );
                setTimeout( function() {
                    setFileProgress( file_or_path );
                }, 5000 );
            });
            */
            
        }
        else
        {
            if (errhandler) errhandler(null,file_or_path);
        }

    }
} 

function loadFileWebsocket( path, istext, handler, errhandler ) {
  // https://learn.javascript.ru/websockets
  var socket = new WebSocket( path );
  socket.onmessage = function(event) {
    handler( event.data );
  };
  
  socket.onerror = function( event ) {
    setFileProgress( path,"WEBSOCKET ERROR");
      setTimeout( function() {
         setFileProgress( path );
       }, 25000 );
    if (errhandler)
      errhandler(event,path);
  }
  var result = {};
  result.abort = function() { socket.close(); }
  result.stoploading = function() { socket.close() }
  return result;
}

