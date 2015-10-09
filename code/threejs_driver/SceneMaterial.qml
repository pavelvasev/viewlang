Item {
  id: mat
  
  function aftermake( obj ) {
  
/*  это теперь делается в функции attachShaders, которая вызывается стандартом в make3dbase
    // obj.shader может быть undefined, шейдером, или массивом шейдеров
    var shaders = obj.shader ? ( obj.shader.length ? obj.shader : [obj.shader] ) : [];
    if (shaders && shaders.length > 0 && shaders[0].attachShaders)
      shaders[0].attachShaders( shaders, this.sceneMaterial, obj );
*/      
  }
  
  
}