PhongMaterial {
  id: mat
 
  // из цветов робят color ambient emissive

  function domakemat( opts ) {
    
    // типо нет этих свойств в Lambert материале
    delete opts.shading;
    delete opts.specular;
    delete opts.shininess;
    //console.log("making lambert",opts);
    return new THREE.MeshLambertMaterial( opts );
  }  
}