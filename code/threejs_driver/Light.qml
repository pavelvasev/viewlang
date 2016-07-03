Item {
  property var color: 0xffffff
  property bool enabled: true

  property var light

  property bool visual: true // надо для svl
 
  onEnabledChanged: update();
  onColorChanged: if (light) light.color = getcolor();
  onVisibleChanged: if (light) light.visible = visible;

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
        //console.log("removed light from scene..... light=",light );
        light = undefined;
      }
      return false;
    }
    return true;
  }  

  Component.onDestruction: if (light) scene.remove( light );

}