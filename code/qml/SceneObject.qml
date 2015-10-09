Item {
  id: it

  property var color: 0xffffff //00aa00
  property var priority: 0
  property var title: "Scene object"
  property var visual: true
  property var source: parent
  property var center: [0,0,0]
  
  property var nesting: false

  property var materials: []  

  property var jsonSources

  property var shader: source ? source.shader : undefined

  // internal
  /* вроде как и не надо, этим теперь материал рулит
  property var shaders: []
  onShaderChanged: {
    if (!shader) {
      it.shaders = [];
      return;
    }
    if (shader.length) 
      it.shaders = shader;
    else
      it.shaders = [shader];
  }
  */

/*  
  property var shader: source ? source.shader : null
  property var shaders: source ? source.shaders : null
  onShaderChanged: it.shaders = [shader];
*/  

  signal render();

  function open( fileNameOrUrl ) {
    //Lazy ладно пока не надо
  }

  Component.onCompleted: {
    // сигнал render... пока ток для three js?
/*
    if (scene && it.render.isConnected())
    scene.addEventListener( 'render', function() { 
      it.render(); 
    });
*/    

//    if (this.doubleClick.isConnected()) {
//    }

//    if (jsonSources) reloadJsonSources(jsonSources);
  }
  
  function make3dbase()
  {
    if (!this.sceneObject) return;
    // name для threejs
    // ушло в threejs-объекты
    // this.sceneObject.name = this.nesting ? this.parent.title + "->" + this.title : this.title;
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