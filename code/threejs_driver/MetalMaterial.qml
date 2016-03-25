PhongMaterial {
  id: mat

  property var metalness: 0.5

  function domakemat( opts ) {
    // типо нет этих свойств в текущем материале
    delete opts.specular;
    delete opts.shininess;
/*а вот эти надо заделать
	this.roughness = 0.5;
	this.metalness = 0.5;
*/
    opts.metalness = mat.metalness;
    return new THREE.MeshStandardMaterial( opts );
  }  

  onMetalnessChanged: {
    if (!this.sceneMaterial) return;
    this.sceneMaterial.metalness = metalness;
    this.sceneMaterial.needsUpdate = true;  
  }
}