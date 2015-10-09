// см D:\sync_data\viewlanging\viewlang\examples\a1_lights\readme.md 
Light {

  property real intensity: 1
  property real radius: 0

  property var position: [0,0,0]
  
  Component.onCompleted: update();

  function update() {
    if (!preupdate()) return;

    if (!light) {
      light = new THREE.SpotLight( 0xff0000, intensity, radius,Math.PI / 2, 1 );
      light.castShadow = true;

      light.shadowMapWidth = 1024;
      light.shadowMapHeight = 1024;

      light.shadowCameraNear = 500;
      light.shadowCameraFar = 4000;
      light.shadowCameraFov = 30;

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
}