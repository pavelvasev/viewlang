// chunk-загрузчик сетки (простая версия)

Item {
  /// вход
  property var file // строка или объект File
  property var mult: 20
  
  /// выход
  property var zones // массив вершин точек по зонам. Первая зона это zones[0] -> массив вершин [x,y,z,x,y,z,...], вторая zones[1] -> [x,y,z,x,y,z,...]
  property var zonesCount: zones.length
  
  /// внутренность
  property var q: load()

  function load() {
    var result = [];
    var zonedata = [];
    var currTail = "";

    loadFileC( file, function(data, first, last, acc ) {
      if (currTail.length > 0) 
         data = currTail + data;
    
      var lines = data.split(/\r*\n+/);
      // http://stackoverflow.com/questions/4964484/why-does-split-on-an-empty-string-return-a-non-empty-array
      if (lines.length == 1 && lines[0] == "") lines.pop();

      currTail = last ? "" : lines.pop();

      console.log("chunk loaded, byte count=",data.length,"lines count=",lines.length);
      
      for (var i=0; i<lines.length; i++) {
        var line = lines[i];

        if (/["]/.test(line)) continue; // пропускаем если есть "

        if (/^\s*ZONE\s+/.test(line)) {
          if (zonedata.length > 0) result.push( zonedata );
          zonedata = [];
          console.log("found new zone: ",line );
          continue;
        }

          var myRe = /\s*([0-9e+-.]+)/g;      
          zonedata.push( parseFloat( (myRe.exec(line) || "0.0") [0] ) * mult );
          zonedata.push( parseFloat( (myRe.exec(line) || "0.0") [0] ) * mult );
          zonedata.push( parseFloat( (myRe.exec(line) || "0.0") [0] ) * mult );
      }
      
      if (last) {
        if (zonedata.length > 0) result.push( zonedata );
        console.log( "chunk parse complete" );
        zones = result;
      }

    }); // обработчик чанка
  } // load




  //////////////////////////////////////////////////////////////////////////////
  // сервисные функции загрузки файлов по-блочно, потом уберем в движок


  // обработчик handler( data, first, last, acc );
  // first = true|false -- первый чанк
  // last = true|false -- последний чанк
  // acc = аккумулятор. но вообще вместо него удобнее контекстом пользоваться

  
  function loadFileC( file_or_path, handler ) {
      return loadFileBaseC( Qt.resolvedUrl(file_or_path), true, handler );
    }

  function loadFileBinaryC( file_or_path, handler ) {
      return loadFileBaseC( Qt.resolvedUrl(file_or_path), false, handler );
    }    


  ////////////////////////////////////////////////////////////////////////////////
    
    function loadFileBaseC( file_or_path, istext, handler ) {
      if (!file_or_path) return handler("",true,true,{} );

      if (file_or_path instanceof File) {
        parseLocalFile( file_or_path,istext,handler );
      }
      else
      {
        if (file_or_path.length == 0) return handler("",true,true,{} );

        setFileProgress( file_or_path,"loading",5);

        jQuery.get( file_or_path, function(data) {
          setFileProgress( file_or_path,"parsing",50);
          handler(data,true,true,{} );
          setFileProgress( file_or_path);
        } );
      }
    }
    


function parseLocalFile(file, istext, callback) 
{
	var fileSize = file.size;
	//var chunkSize = 16 * 1024 * 1024; // FIX
	var chunkSize = 2 * 1024 * 1024; // FIX
	
	var offset = 0;
	var block = null;
	var firstChunk = true;

	var accumulator = {}; 

	function updateProgress(evt,msg) {
		var percentLoaded = Math.round((offset / fileSize) * 100);
		setFileProgress( file.name,msg || "loading", percentLoaded ); // функция движка
	}

	var blockLoaded = function(evt) {
		if (evt.target.error == null) {
			offset += evt.target.result.length;
			updateProgress( 0,"parsing" );

			//if (offset < fileSize) blockLoad(offset, chunkSize, file);

			callback(evt.target.result, firstChunk, offset >= fileSize, accumulator );
			firstChunk = false;
		} else {
			console.log("Read error: " + evt.target.error);
			setFileProgress( file.name,"read error", -1 );
			return;
		}
			
		if (offset >= fileSize) { 
		    setFileProgress( file.name,"", -1 );
		    return;
		}

		blockLoad(offset, chunkSize, file);

		// TODO замерить: 1. Скорости загрузки при разных chunk-size. 2. Как влияет вынос blockload перед обработкой по callback.
	}

	blockLoad = function(_offset, length, _file) {
		var r = new FileReader();
		var blob = _file.slice(_offset, length + _offset);
		
		r.onload = blockLoaded;
		r.onprogress = updateProgress;

		if (_offset == 0) {
		    setFileProgress( file.name,"loading", 0 );
			r.onloadstart = function(e) {
			    setFileProgress( file.name,"loading", 1 );
			};
		};
	
	    if (istext)
			r.readAsText(blob);
		else
		    reader.readAsArrayBuffer(blob);
	}

	blockLoad(offset, chunkSize, file);
}
  
  
}