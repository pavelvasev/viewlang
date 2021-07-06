SceneObject {
    id: theobj

    onCenterChanged: {
      //console.log( "setted to ",center )
      this.sceneObject && this.sceneObject.position.fromArray(center);
    }
    onRotateChanged: {
      // console.log( "setted to ",rotate )
      this.sceneObject && this.sceneObject.rotation.fromArray(rotate);
    }
    onScaleChanged: this.sceneObject && this.sceneObject.scale.set(scale,scale,scale);

    onShaderChanged: attachShaders();

    property var threeJsSceneObject: theobj
    
    onMaterialsChanged: {
        makeLater(this);
    }

    property bool hasAttachedShaders: false
    function  attachShaders()
    {
        cleanupShaders();
        
        if (this.sceneObject && this.sceneObject.material) {

          var shaders = flattenArrayOfArrays( theobj.shader );
          //console.error("I am sceneobject",theobj);
          //console.error("found shaders:",shaders);
          
          // ищем первый ненулевой шейдер, вызываем у него метод прицепления всех шейдеров. но вообще конечно страно..
          // а как иначе? где держать логику прицепления шейдеров?..
          // ну да, логика такая - мы находим первый объект, у которого есть attachShaders, и вызываем у него этот метод 1 раз но для всех указанных шейдеров
          if (shaders && shaders.length > 0) {
            for (var i=0; i<shaders.length; i++) {
              //console.log("inspecting ",shaders[i]);
              if (shaders[i].attachShaders) {
                //console.log("attaching ",shaders[i]);
                shaders[i].attachShaders( shaders, this.sceneObject.material, theobj );
                hasAttachedShaders = true;
                break;
              }
              //else console.log("inspect failed"); ничего страшного если оно не шейдер
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
    
    // performs cleanup from shaders.. safe to call before attachShaders
    function cleanupShaders() {
      if (theobj.shadersDetachFunc) {
        theobj.shadersDetachFunc(); 
        theobj.shadersDetachFunc = undefined;
      }
    }

    function make3dbase()
    {
      if (!this.sceneObject) return;

      if (!this.parent) {
        this.clear();
        return;
      }
      
      // an unique patch - do not use frustrum culling for any objects
      // because it have (?) bugs in three-js - in our practice sometimes
      // objects are culled-out while they shouldn't
      this.sceneObject.frustumCulled = false;

      if (renderOrder) { this.sceneObject.renderOrder = renderOrder; }

      // name для threejs
      this.sceneObject.name = this.nesting && this.parent ? this.parent.title + "~>" + this.title : this.title;
      this.sceneObject.qmlParent = this;
      centerChanged();
      visibleChanged();
      attachShaders();
      scaleChanged();
      rotateChanged();
      
      this.sceneObject.frustumCulled = theobj.frustumCulled;

      // && theobj.frustrumCulledPossible();

      makecnt = makecnt+1;
    }
    
    function frustrumCulledPossible() { }

    property int makecnt: 0

    onVisibleChanged: {
        //makeLater(this);
        if (this.sceneObject) {
          //console.log("theejs set visible=",visible);
          this.sceneObject.visible = visible && extraVisible();
        }
    }
    
    function extraVisible()
    {
      var source = theobj;
      if (source["radiusChanged"])
         return source.radius > 0 && source.opacity > 0;
      else
      if (source.play)  // camera or video
      { // do nothing
      }
      else {
       return source.opacity > 0;
      }
      return true;
    }

    function intersect( pos, threshold ) {
      if (!this.sceneObject) return null;

      raycaster.params.Points.threshold = threshold ? threshold : (theobj.radius ? 0.03 + theobj.radius/2 : 0.1); // этим параметром надо как-то управлять уметь..
      //console.log(" we use raycaster.params.PointCloud.threshold=",raycaster.params.PointCloud.threshold);
      // вот, попробовали поуправлять через радиус...
      
  	  raycaster.setFromCamera( pos, camera );
			var intersects = raycaster.intersectObject( this.sceneObject,false );
			//console.log("intersects=",intersects, "pos=",pos);
			if (intersects.length == 0) return null;

			var intersect = intersects[0];
			return intersect;
	  }    

    function somethingToColor( theColorData )
    {
      return theColorData.length && theColorData.length >= 3 ? new THREE.Color( theColorData[0], theColorData[1], theColorData[2] ) : new THREE.Color(theColorData);
    }

    Component.onDestruction: {
      clear();
      cleanupShaders();
    }
    
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