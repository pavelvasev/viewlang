SceneMaterial {
  id: mat

  property var source: parent

  property var color: {
    if (!source) { 
//      debugger;
//      console.log("source=",source);
        return [1,1,0];
    }
    return source.color;
  }
  property var ambient: 0xffffff // 0xaaaaaa
  property var specular: 0x888888  //0x444444 // 0xffffff 
  property var emissive: 0x000000

  property var shine: 250
  property var metal: true
  property var wire: source.wire

  property var opacity: source.opacity
  property var transparent: source.transparent

  property var shading: {
    //console.log("imma phong flat=",flat, "parent=",parent );
    //debugger;
    return flat ? 1 : 2;
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
      this.sceneMaterial.needsUpdate = true;  
  }

  onOpacityChanged: {
      if (!this.sceneMaterial) return;
      this.sceneMaterial.opacity = opacity;
      this.sceneMaterial.transparent = opacity < 1;
      this.sceneMaterial.needsUpdate = true;  
  }  
  
  function somethingToColor( theColorData )
  {
    if (!theColorData) {
//      debugger;
      return new THREE.Color(1,1,0);
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
            ambient: mat.ambient, 
            specular: mat.specular, 
            emissive: mat.emissive, 
            shininess: mat.shine, 
            side: THREE.DoubleSide ,
            metal: mat.metal,
            shading: mat.shading
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