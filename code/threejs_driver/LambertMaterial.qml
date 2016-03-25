PhongMaterial {
  id: mat
 
  // из цветов робят color ambient emissive

  function domakemat( opts ) {
    // console.log("making lambert");
    // типо нет этих свойств в Lambert материале
    delete opts.shading;
    delete opts.specular;
    delete opts.shininess;
    return new THREE.MeshLambertMaterial( opts );
  }  
}