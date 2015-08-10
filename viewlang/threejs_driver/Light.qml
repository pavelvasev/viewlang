Item {
  property var color: 0xffffff
  property bool enabled: true

  property var light
 
  onEnabledChanged: update();
  onColorChanged: if (light) light.color = getcolor();

  function getcolor() { return somethingToColor(color); }
  
  function somethingToColor( theColorData )
  {
    return theColorData.length && theColorData.length >= 3 ? new THREE.Color( theColorData[0], theColorData[1], theColorData[2] ) : new THREE.Color(theColorData);
  }  

  function update() { 
    preupdate();
  }

  function preupdate() { 
    if (!enabled) {
      if (light) {
        scene.remove( light );
        light = undefined;
      }
      return false;
    }
    return true;
  }  

  Component.onDestruction: if (light) scene.remove( light );

}