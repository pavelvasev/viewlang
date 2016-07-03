Light {
  id: pl
  property var robotIcon: "fa-lightbulb-o"

  property real intensity: 1
  property real radius: 0

  property var position: [0,0,0]
  property alias center: pl.position
  
  Component.onCompleted: update();

  function update() {
    var pre = preupdate();
    //console.log("PointLight: update, preupdate returned ",pre);
    if (!pre) return;

    if (!light) {
      //console.log("PointLight: adding light to scene..");
      light = new THREE.PointLight( 0xff0000, intensity, radius );
      scene.add( pl.light );
    }
    colorChanged();
    intensityChanged();
    radiusChanged();
    positionChanged();
  }
  
  onPositionChanged: {
    //console.log("PointLight position change, light=",pl.light,"position=",position);
    if (light) light.position.set( position[0],position[1],position[2] );
  }
  onIntensityChanged: if (light) light.intensity = intensity;
  onRadiusChanged: if (light) light.distance = radius;

  /*
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
  */

}