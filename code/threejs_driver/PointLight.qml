Light {

  property real intensity: 1
  property real radius: 0

  property var position: [0,0,0]
  
  Component.onCompleted: update();

  function update() {
    if (!preupdate()) return;

    if (!light) {
      light = new THREE.PointLight( 0xff0000, intensity, radius );
      scene.add( light );
    }
    colorChanged();
    intensityChanged();
    radiusChanged();
    positionChanged();
  }
  
  onPositionChanged: if (light) light.position.set( position[0],position[1],position[2] );
  onIntensityChanged: if (light) light.intensity = intensity;
  onRadiusChanged: if (light) light.distance = radius;

  Spheres {
    nx: 4
    ny: 4
    wire: true
    opacity: 0.5
    color: parent.color
    positions: parent.position
    radius: 1
    visible: rootScene.showLights
  }

}