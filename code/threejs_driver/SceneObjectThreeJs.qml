SceneObject {
    id: theobj

    onCenterChanged: this.sceneObject && this.sceneObject.position.fromArray(center);

    onShaderChanged: attachShaders();

    property var threeJsSceneObject: theobj
    
    onMaterialsChanged: {
        makeLater(this);
    }

/*  
    ShaderLogic {
      id: shaderLogic
    }
*/  
    property bool hasAttachedShaders: false
    function  attachShaders()
    {
        if (this.sceneObject && this.sceneObject.material) {
          // console.log( "sceneobjecttjs: attachShaders ", theobj.shader);

          var shaders = flattenArrayOfArrays( theobj.shader );

//          shaderLogic.attachShaders( shaders );
          
          // ищем первый ненулевой шейдер, вызываем у него метод прицепления всех шейдеров. но вообще конечно страно..
          // а как иначе? где держать логику прицепления шейдеров?..
          if (shaders && shaders.length > 0) {
            for (var i=0; i<shaders.length; i++)
              if (shaders[i].attachShaders) {
                shaders[i].attachShaders( shaders, this.sceneObject.material, theobj );
                hasAttachedShaders = true;
                break;
              }
          } else {
            if (hasAttachedShaders) {
              console.log("hasAttachedShaders clearing");
              // если были шейдеры, а теперь не стало.. пересоздадим фсё, и материал заодно
              //this.sceneObject.material.dispose();
              //this.sceneObject.material = null;
              //нет в мире совершенства, и тут уж не будет. 
              this.sceneObject.material.recreate = true;
              makeLater( this );
              
              hasAttachedShaders = false;
            }
          }

        }
    }

    function make3dbase()
    {
      if (!this.sceneObject) return;
      // name для threejs
      this.sceneObject.name = this.nesting ? this.parent.title + "->" + this.title : this.title;
      centerChanged();
      visibleChanged();
      attachShaders();
    }    

    onVisibleChanged: {
        //makeLater(this);
        if (this.sceneObject) {
          //console.log("theejs set visible=",visible);
          this.sceneObject.visible = visible;
        }
    }

    function intersect( pos, threshold ) {
      if (!this.sceneObject) return null;

      raycaster.params.PointCloud.threshold = threshold ? threshold : (theobj.radius ? 0.03 + theobj.radius/2 : 0.1); // этим параметром надо как-то управлять уметь..
      //console.log(" we use raycaster.params.PointCloud.threshold=",raycaster.params.PointCloud.threshold);
      // вот, попробовали поуправлять через радиус...
      
  	  raycaster.setFromCamera( pos, camera );
			var intersects = raycaster.intersectObject( this.sceneObject,false );
			// console.log("intersects=",intersects);
			if (intersects.length == 0) return null;

			var intersect = intersects[0];
			return intersect;
	  }    

    function somethingToColor( theColorData )
    {
      return theColorData.length && theColorData.length >= 3 ? new THREE.Color( theColorData[0], theColorData[1], theColorData[2] ) : new THREE.Color(theColorData);
    }

    Component.onDestruction: clear();
    
    /* конечно хорошо что они тут спрятаны - типа один раз всем. но это же и плохо, ибо становится неявно.
       в общем пока что каждый должен сам свое clear предоставлять
    function clear() {
      clearobj( this.sceneObject ); 
      this.sceneObject = undefined;
    }
    
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
    */

}