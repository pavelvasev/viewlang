SceneObjectThreeJs {
    property var positions: source.positions

    property var color: 0xff
    property var colors
    property var radius: 0.25

    property var priority: 0

    property var linestrip: false
    property var dashed: false

    // @WithSelectOne.qml 
    property var positionItemSize: 6

    /////////////////// graphics part
    id: qmlObject

    onPositionsChanged: {
        //console.log("changed, scheduling remake of lines");
        makeLater( this );
    }
    
    onColorsChanged: {
        makeLater(this);
    }

    onColorChanged: {
        makeLater(this);
    }
        
    onOpacityChanged: {
      if (!this.sceneObject || !this.sceneObject.material) return;
      this.sceneObject.material.opacity = opacity;
      this.sceneObject.material.transparent = opacity < 1;
      this.sceneObject.material.needsUpdate=true;
    }

    onDashedChanged: makeLater(this);

    onRadiusChanged: {
      if (!this.sceneObject || !this.sceneObject.material) return;
      this.sceneObject.material.linewidth = radius;
      this.sceneObject.material.needsUpdate=true;    
    }

  function somethingToColor( theColorData )
  {
    return theColorData.length && theColorData.length >= 3 ? new THREE.Color( theColorData[0], theColorData[1], theColorData[2] ) : new THREE.Color(theColorData);
  }

    function make3d()
    {
        var colors_good = (colors && positions && colors.length > 0) ? positions.length/3 == colors.length/3 : true;
        var geom_good = (positions ? true : false);

        if (!(colors_good && geom_good)) {
            //debugger;
            console.log("Lines::make3d() exiting, because conditions on colors and geometry fail. geom_good=",geom_good,"colors_good=",colors_good);
            return;
        }

        clear();

        /////////////////////////////////
        var geometry = new THREE.BufferGeometry();


        if (positions)
            geometry.setAttribute( 'position', new THREE.BufferAttribute( new Float32Array(positions), 3 ) );
            
        if (colors && colors.length > 0) {
            geometry.setAttribute( 'color', new THREE.BufferAttribute( new Float32Array(colors), 3 ) );
            //console.log("colors to lines loaded");
        }
            
        geometry.computeBoundingSphere();
    
        
        var materialOptions = {}
        
        if (colors && colors.length > 0)
            materialOptions.vertexColors = THREE.VertexColors;
        else
            materialOptions.color = somethingToColor( color ); // если выставлять color одновременно с colors, то color будет как бы маской. это прикольно, но пока не то что нам надо.

        //var material = new (dashed ? THREE.LineDashedMaterial : THREE.LineBasicMaterial)( materialOptions );
        var material = 0;
        if (dashed) {
           material = new THREE.LineDashedMaterial( materialOptions );
           // 112 geometry.computeLineDistances();
        }
        else
           material = new THREE.LineBasicMaterial( materialOptions );

        /////////////////////////////////
        this.sceneObject = linestrip ? new THREE.Line( geometry, material ) : new THREE.LineSegments( geometry, material );  //,linestrip ? THREE.LineStrip : THREE.LinePieces );
        
        if (dashed)
          this.sceneObject.computeLineDistances(); // 112

        opacityChanged();
        radiusChanged();

        scene.add( this.sceneObject );
        make3dbase();
        //console.log('lines done',positions);
    }

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
    
}
