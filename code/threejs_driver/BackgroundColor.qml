// цвет фона сцены
// доступ: scene.backgroundColor и scene.backgroundOpacity
Item {
  id: item

  property var color  

  onColorChanged: update()
  onOpacityChanged: update()

  function update() {
    if (!threejs || !threejs.renderer || !threejs.renderer.getClearColor || !threejs.renderer.setClearColor) return;
    var cc = color ? somethingToColor( color ) : threejs.renderer.getClearColor();
    threejs.renderer.setClearColor( cc, opacity);
  }

  function somethingToColor( theColorData )
  {
    return theColorData.length && theColorData.length >= 3 ? new THREE.Color( theColorData[0], theColorData[1], theColorData[2] ) : new THREE.Color(theColorData);
  }
}