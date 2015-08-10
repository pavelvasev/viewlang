/////////////////////////////////////////////////////////////////////////////// не используется пока
// http://www.henryalgus.com/reading-binary-files-using-jquery-ajax/
// https://github.com/henrya/js-jquery/blob/master/BinaryTransport/jquery.binarytransport.js

/** Copyright (c) 2014 Henry Algus
 *
 * jquery.binarytransport.js
 *
 * @description. jQuery ajax transport for making binary data type requests.
 * @version 1.0
 * @author Henry Algus <henryalgus@gmail.com>
 *
 */

// use this transport for "binary" data type
$.ajaxTransport("+binary", function(options, originalOptions, jqXHR){
    // PV: we force arraybuffer to come
    options.responseType = "arraybuffer";
    options.processData = false;

    // check for conditions and support for blob / arraybuffer response type
    if (window.FormData && ((options.dataType && (options.dataType == 'binary')) || (options.data && ((window.ArrayBuffer && options.data instanceof ArrayBuffer) || (window.Blob && options.data instanceof Blob)))))
    {
        return {
            // create new XMLHttpRequest
            send: function(headers, callback){
                // setup all variables
                var xhr = new XMLHttpRequest(),
                        url = options.url,
                        type = options.type,
                        async = options.async || true,
                        // blob or arraybuffer. Default is blob
                        dataType = options.responseType || "blob",
                        data = options.data || null,
                        username = options.username || null,
                        password = options.password || null;

                xhr.addEventListener('load', function(){
                    var data = {};
                    data[options.dataType] = xhr.response;
                    // make callback and send data
                    xhrSuccessStatus = {
                        // file protocol always yields status code 0, assume 200
                        0: 200,
                        // Support: IE9
                        // #1450: sometimes IE returns 1223 when it should be 204
                        1223: 204
                    }

                    callback(xhrSuccessStatus[xhr.status] || xhr.status, xhr.statusText, data, xhr.getAllResponseHeaders());
                });

                xhr.open(type, url, async, username, password);

                // setup custom headers
                for (var i in headers ) {
                    xhr.setRequestHeader(i, headers[i] );
                }

                xhr.responseType = dataType;
                xhr.send(data);
            },
            abort: function(){}
        };
    }
});
