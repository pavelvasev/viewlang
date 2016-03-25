Item {
  id: it

  property var color: 0xffffff //00aa00
  property var priority: 0
  property var title: "Scene object"
  property var visual: true
  property var source: parent
  property var center: [0,0,0]
  property var rotate: [0,0,0]
  property var scale: 1

  property var renderOrder
  
  property var nesting: false

  property var materials: []  

  property var jsonSources

  property var shader: source ? source.shader : undefined

  // internal

  signal render();

  function open( fileNameOrUrl ) {
    //Lazy ладно пока не надо
  }

  Component.onCompleted: {
  }
  
  function make3dbase()
  {
    if (!this.sceneObject) return;
  }


    ///////////////////////////////////////////////// 

    onJsonSourcesChanged: loadJsonSources(jsonSources);
    
    function loadJsonSources(srcs)
    {
      console.log("loadJsonSources...",srcs);
      if (!srcs || srcs.length == 0) return;
      
      if (!Array.isArray(srcs)) srcs = [srcs];

      for (var i=0; i<srcs.length; i++) {
         var src = srcs[i];
         if (!src || src.length == 0) continue;
      loadFile(src, function(res) {
        var p = parseJson(res);
        //console.log(p);
        
        for (k in p) {
          if (p.hasOwnProperty(k)) {
            
            it[k] = p[k];
          }
        }
         
      } ); //loadfile

      } // for
      
    }

}