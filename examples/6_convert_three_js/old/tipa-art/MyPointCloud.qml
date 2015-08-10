// Пример того, как имея ThreeJS-сущность превратить ее в Viewlang-объект

SceneObjectThreeJs { // используем спец. базовый класс
    id: obj

    /////////////////// входные данные. могут быть любыми, по вашему выбору.
    
    property var data
    property var color: 0x0000ff
    property var radius: 0.1

    property var center: [0,0,0]

    ////////////////////// обработка изменений входных данных

    onDataChanged: makeLater(this);
    onColorChanged: makeLater(this);

    onCenterChanged: this.sceneObject && this.sceneObject.position.fromArray(center);
    
    onRadiusChanged: {
      makeLater(this); return;
      if (!this.sceneObject || !this.sceneObject.material) return;
      this.sceneObject.material.size=radius;
      this.sceneObject.material.needsUpdate=true;
    }

    onOpacityChanged: {
      if (!this.sceneObject || !this.sceneObject.material) return;
      this.sceneObject.material.opacity = opacity;
      this.sceneObject.material.transparent = opacity < 1;
      this.sceneObject.material.needsUpdate=true;
          
//      if (!obj.sceneObject) return makeLater(this);
//      var mat = obj.sceneObject.material;
//      mat.needsUpdate = true;  
    }
    

    /////////////////// Создание Three-js сущностей по требованию -- когда viewlang вызывает функцию make3d
    
    /* вызывается для преобразования текущего qml-объекта в threejs-сущности
       повторные вызовы означают что объект необходимо пере-преобразовать заново (не забыв почистить то что было создано ранее)
       Доступные для использования переменные объектов threejs:
       
       * threejs.scene
       * threejs.sceneControl
       * threejs.camera
       * threejs.renderer

       Также уже загружена библиотека jQuery. 
    */

    function make3d() {
      // проверка что свойства установлены (в qmlweb на ранних этапах они могут содержать undefined)
      if (!data) return; 
      
      clear(); // очистка ранее созданного
      
      // /////////////////////////////////  поехали

      // лучше делать ето на шейдерах

      var geometry = new THREE.BufferGeometry();
      var acc = [];
      var nn = 5, rr = radius/5;
      var rrr = rr/4;
      for (var i=0; i<data.length; i+=3)
      {
        var x = data[i], y=data[i+1], z=data[i+2];
        for (var j=0; j< nn; j++) {
          var a = 2*3.14152 * j/nn;


          /* непонятно */
          /*
          acc.push( x + Math.cos(a)*rr + Math.random()*rrr );
          acc.push( y + Math.sin(a)*rr + Math.random()*rrr );
          acc.push( z + Math.cos(a)*Math.sin(a)*rr + Math.random()*rrr );
          */
          
          
          /* математично
          acc.push( x + Math.cos(a)*rr );
          acc.push( y + Math.sin(a)*rr );
          acc.push( z + Math.cos(a)*Math.sin(a)*rr );
          */
          
          
          /* артистично */
          
          acc.push( x + Math.random()*rr );
          acc.push( y + Math.random()*rr );
          acc.push( z + Math.random()*rr );
          
          
        }

      }
      geometry.addAttribute( 'position', new THREE.BufferAttribute( new Float32Array(acc), 3 ) );
      geometry.computeBoundingSphere();
      
      var c = somethingToColor( color ); 
      
      var materialOptions = {
          color:c, 
          size: radius/5, 
          transparent: (opacity < 1), 
          opacity: opacity 
      }
      var material = new THREE.PointCloudMaterial( materialOptions );
      
      // this.sceneObject будет хранить созданный объект threejs-а. 
      // теоретически можно хранить не только этот объект, а и другие.
      // но практически желательно иметь только 1 three-js объект в каждом qml-объекте

      this.sceneObject = new THREE.PointCloud( geometry, material );
      this.sceneObject.visible = visible;
      
      if (center) {
        this.sceneObject.position.fromArray( center ); 
        console.log( "setted center",this.sceneObject.position);
      }

      threejs.scene.add( this.sceneObject );
      make3dbase();
      console.log("make3d finished");
    }
    
    function clear() {
      clearobj( this.sceneObject ); 
      this.sceneObject = undefined;
    }

    /// вспомогательные функции
    
    function clearobj(obj) {
        if (obj) {
            // http://stackoverflow.com/questions/12945092/memory-leak-with-three-js-and-many-shapes
            // http://mrdoob.github.io/three.js/examples/webgl_test_memory.html

            scene.remove( obj );
            obj.geometry.dispose();
            obj.material.dispose();
            if (obj.texture)
                obj.texture.dispose();
        }
    }

    function somethingToColor( theColorData )
    {
      return theColorData.length && theColorData.length >= 3 ? new THREE.Color( theColorData[0], theColorData[1], theColorData[2] ) : new THREE.Color(theColorData);
    }

    Component.onCompleted: {
      console.log("my component created" );
    }

    Component.onDestruction: {
      // место очистки - созданных dom и threejs объектов
      clear();

      console.log("my component deleted" );
    }
}
