SceneMaterial {
  id: mat

  property var source: parent

  property var color: {
    if (!source) { 
//      debugger;
//      console.log("source=",source);
       
        return [1,1,1];
    }
    return source.color;
  }
  property var ambient: 0xffffff // 0xaaaaaa - в threejs r75 не влияет
  property var specular: 0x888888  //0x444444 // 0xffffff 
  property var emissive: 0x000000

  property var shine: 250
  property var metal: true
  property var wire: source.wire
  property var wirewidth: 1

  property var opacity: source.opacity
  property var transparent: source.transparent

  property var shading: {
    //console.log("imma phong flat=",flat, "parent=",parent );
    //debugger;
    // for some back-compat
    return flat ? 1 : 2;
  }
  
  property var flat: false
  onFlatChanged: {
    if (!this.sceneMaterial) return;
    this.sceneMaterial.flatShading  = flat;
    this.sceneMaterial.needsUpdate = true;  
  }

/* three js
THREE.NoShading = 0;
THREE.FlatShading = 1;
THREE.SmoothShading = 2;
*/

  onColorChanged: {
    if (!this.sceneMaterial) return;
    this.sceneMaterial.color = somethingToColor(color);
    this.sceneMaterial.needsUpdate = true;  
  }

  onShineChanged: {
    if (!this.sceneMaterial) return;
    this.sceneMaterial.shininess = shine;
    this.sceneMaterial.needsUpdate = true;  
  }

  onWireChanged: {
      if (!this.sceneMaterial) return;
      this.sceneMaterial.wireframe = wire;
      this.sceneMaterial.wireframeLinewidth = wirewidth;
      this.sceneMaterial.needsUpdate = true;  
  }
  onWirewidthChanged: wireChanged();

  onOpacityChanged: {
      if (!this.sceneMaterial) return;
      this.sceneMaterial.opacity = opacity;
      this.sceneMaterial.transparent = opacity < 1;
      this.sceneMaterial.needsUpdate = true;  
  }  
  
  function somethingToColor( theColorData )
  {
    if (!theColorData) {
       // in case if color not specified, we should return white, because `colors` may be still specified (and they will be mixed with this color, which in case of not white will bring wrong final coloring).
      return new THREE.Color(1,1,1);
    }
    return theColorData.length && theColorData.length >= 3 ? new THREE.Color( theColorData[0], theColorData[1], theColorData[2] ) : new THREE.Color(theColorData);
  }

  function makeMaterial( obj ) {
        if (this.sceneMaterial && !this.sceneMaterial.recreate) return this.sceneMaterial;
  
        source = obj;
        var theColorData = color;
        //console.log( theColorData,color,obj.color );
        var theColor = somethingToColor( theColorData );
        //var theColor = 0xffffff;
        
        var materialOptions = {
            color: theColor, 
            //ambient: mat.ambient,  r75
            specular: mat.specular, 
            emissive: mat.emissive, 
            shininess: mat.shine, 
            side: THREE.DoubleSide,
            // metal: mat.metal, r75
            flatShading: flat
        };
        //console.log("used mat shading=",mat.shading,flat);

        if (obj.colors && obj.colors.length > 0)
            materialOptions.vertexColors = THREE.VertexColors;

        if (wire)
            materialOptions.wireframe = true;

        if (opacity < 1 || transparent) {
            materialOptions.transparent = true;
            materialOptions.opacity = opacity;
        }
        
        //console.log("materialOptions=",materialOptions);
        this.sceneMaterial = domakemat( materialOptions );

        aftermake( obj );
        
			  return this.sceneMaterial;
  }

  function domakemat( opts ) {
    return new THREE.MeshPhongMaterial( opts );
  }

}