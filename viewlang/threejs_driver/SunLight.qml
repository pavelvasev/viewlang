Light {

  property real intensity: 1
  property var position: [0,0,0]
  
  Component.onCompleted: update();

  function update() {
    if (!preupdate()) return;

    if (!light) {
      light = new THREE.DirectionalLight( 0xff0000, intensity );
      scene.add( light );
    }
    colorChanged();
    intensityChanged();
    positionChanged();
  }
  
  onPositionChanged: if (light) light.position.set( position[0],position[1],position[2] );
  onIntensityChanged: if (light) light.intensity = intensity;
}