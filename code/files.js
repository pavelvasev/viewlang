

/////////////////////////////////////////////////////////////


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
                      return;
                    }
                    setFileProgress( file_or_path.name );
                },5 );

            };

            if (istext)
                reader.readAsText( file_or_path );
            else
                reader.readAsArrayBuffer( file_or_path );

        }, 5); //window.setTimeout

        var result = {};
        result.abort = function() { reader.abort(); setFileProgress( file_or_path.name ); }
        return result;
    }
    else
    {
        if (file_or_path && file_or_path.content) {
          handler( file_or_path.content, "data" );
          return;
        }

        if (file_or_path && file_or_path.length > 0) {
            setFileProgress( file_or_path,"loading");

            var xhr = new XMLHttpRequest();
            xhr.open('GET', file_or_path, true);
            xhr.responseType = istext ? 'text' : 'arraybuffer';

            xhr.onload = function(e) {
							  //console.log("xhr loadFileBase onload fired",file_or_path);            
                // response is unsigned 8 bit integer
                //var responseArray = new Uint8Array(this.response);
                setFileProgress( file_or_path,"parsing");
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

                setFileProgress( file_or_path );
            };

            xhr.onerror = function(e) {
                setFileProgress( file_or_path,"AJAX READ ERROR");
                setTimeout( function() {
                    setFileProgress( file_or_path );
                }, 25000 );
                console.log("xhr error. file_or_path=",file_or_path);
                if (errhandler) errhandler(e,file_or_path); // но вообще это спорно, то что мы передаем вторым параметром урль..
            }

            xhr.send();

            var result = {};
            result.abort = function() { xhr.abort(); setFileProgress( file_or_path ); }
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

function parseJson( text )
{
    return JSON.parse(text);
}

