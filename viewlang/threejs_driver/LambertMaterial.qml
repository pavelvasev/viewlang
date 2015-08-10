PhongMaterial {
  id: mat
 
  // из цветов робят color ambient emissive

  function domakemat( opts ) {
    console.log("making lambert");
    return new THREE.MeshLambertMaterial( opts );
  }  
}