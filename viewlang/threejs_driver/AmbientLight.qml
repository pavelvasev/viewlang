Light {
  Component.onCompleted: update();

  function update() {
    if (!preupdate()) return;

    if (!light) {
      light = new THREE.AmbientLight( 0x444444 ); // soft white light
      scene.add( light );
    }
    colorChanged();

    if (sceneObj.rootScene.light0 !== this) 
        sceneObj.rootScene.light0.enabled = false;
  }

}