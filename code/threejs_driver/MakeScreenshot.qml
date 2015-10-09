Item {
  function perform() {
    var img = renderer.domElement.toDataURL("image/png");  
    return img;
  }
}