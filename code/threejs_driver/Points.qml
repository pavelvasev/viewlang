SceneObjectThreeJs {
    property var positions: source.positions

    property var color: 0x0000ff
    property var colors
    property var radius: 0.25

    property var priority: 0

    /////////////////// graphics part
    id: qmlObject

    onColorChanged: {
      if (!this.sceneObject || !this.sceneObject.material) return;
      
      this.sceneObject.material.color=somethingToColor(color);
      this.sceneObject.material.needsUpdate=true;
    }
    

    onRadiusChanged: {
      if (!this.sceneObject || !this.sceneObject.material) return;
      this.sceneObject.material.size=radius;
      this.sceneObject.material.needsUpdate=true;
    }

    onPositionsChanged: {
//        console.log("changed, scheduling remake of points");
        makeLater( this );
        /*
        if (!this.sceneObject) return;
                if (positions)
                this.sceneObject.geometry.addAttribute( 'position', new THREE.BufferAttribute( new Float32Array(positions), 3 ) );

        var attr = this.sceneObject.geometry.getAttribute("position");
        //attr.set( new Float32Array(positions) );
        attr.needsUpdate = true;
        */
    }
    
    onColorsChanged: {
    
        if (!this.sceneObject) return;
        var colors_good = (colors && positions && colors.length > 0) ? positions.length/3 == colors.length/3 : true;
        var have_colors = (colors && colors.length > 0);
        var use_colors = (have_colors && colors_good);

        if (!use_colors) {
           this.sceneObject.material.vertexColors = THREE.NoColors;
           this.sceneObject.material.needsUpdate = true;
           this.sceneObject.material.color = somethingToColor( color );
           return;
        } 
        if (this.sceneObject.material.vertexColors != THREE.VertexColors) {
           this.sceneObject.material.vertexColors = THREE.VertexColors;
           this.sceneObject.material.color = new THREE.Color( 0xffffff );
           this.sceneObject.material.needsUpdate = true;
        };

        var attr = this.sceneObject.geometry.getAttribute("color");
        if (attr && attr.array.length >= colors.length ) { // есть место
          //console.log("set new colors");
          //attr.set( new Float32Array(colors) );
          attr.set( colors );
          attr.needsUpdate = true;
        } else {
          //console.log("create set new colors");
          this.sceneObject.geometry.addAttribute( 'color', new THREE.BufferAttribute( new Float32Array(colors), 3 ) );
        }
        
        //makeLater(this);
        /*
        if (qmlObject.sceneJsRootNode && qmlObject.sceneJsGeometryNode.getColors() && qmlObject.sceneJsGeometryNode.getColors().length == qmlObject.colors.length)
            qmlObject.sceneJsGeometryNode.setColors( { colors: qmlObject.colors } );
        else
            makeLater( qmlObject );
        */
    }

    onOpacityChanged: setupOpacity();
    
    function setupOpacity() {
      if (!qmlObject.sceneObject) return makeLater(this);

      var mat = qmlObject.sceneObject.material;
      if (!mat) return;

      mat.opacity = opacity;
      //mat.transparent = (opacity < 1); // || (!!textureUrl);
		  mat.transparent = transparent;
		  //console.log( "mat.transparent=",mat.transparent);
      mat.blending = additive ? THREE.AdditiveBlending : THREE.NormalBlending;
      mat.depthTest = depthTest;
      mat.depthWrite = depthWrite;

      mat.needsUpdate = true;  
    }
    
    property var transparent: (opacity < 1) || (!!textureUrl)
    onTransparentChanged: setupOpacity();
        
    property var textureUrl: null
    onTextureUrlChanged: setupTexture();
    
    property var alphaTest: 0.5
    onAlphaTestChanged: setupTexture();

    property var additive: false
    onAdditiveChanged: setupOpacity();
    property var depthTest: true
    onDepthTestChanged: setupOpacity();    
    property var depthWrite: true
    onDepthWriteChanged: setupOpacity();        
    
    function setupTexture() {
      
      if (!qmlObject.sceneObject) return makeLater(this);

      var mat = qmlObject.sceneObject.material;
      
      if (!mat) return;
      
      if (qmlObject.loadedTextureUrl !== textureUrl) {
        if (textureUrl && textureUrl.length > 0) {
          var loader = new THREE.TextureLoader();
		      // loader.setCrossOrigin( undefined );
          qmlObject.loadedTexture = loader.load( textureUrl );
          qmlObject.loadedTextureUrl = textureUrl;
        }
        else
          qmlObject.loadedTexture = textureUrl;
      }
      
      if (qmlObject.loadedTexture !== mat.map) {
        
        mat.map = qmlObject.loadedTexture;
//        console.log("mat.map = ",mat.map  );

        mat.alphaTest = alphaTest;
        
//        mat.alphaTest = 0.2;
//        mat.transparent = true;
//        qmlObject.sceneObject.sortParticles = true;

//        var material = mat;
//        material.blending = THREE.AdditiveBlending;
				//material.transparent = true;
				//qmlObject.sceneObject.sortParticles = true;
//				material.depthWrite = false;

        //mat.blending = THREE.AdditiveBlending;
        //mat.depthTest = false;
        mat.needsUpdate = true;
      }
      
    }
    
  function somethingToColor( theColorData )
  {
    return theColorData.length && theColorData.length >= 3 ? new THREE.Color( theColorData[0], theColorData[1], theColorData[2] ) : new THREE.Color(theColorData);
  }

    function make3d()
    {
        //console.log("Points make3d... positions.length=",positions ? positions.length : -1);
//        var colors_good = (colors && positions && colors.length > 0) ? positions.length/3 == colors.length/3 : true;
        var geom_good = (positions ? true : false);

//        var have_colors = (colors && colors.length > 0);
//        var use_colors = (have_colors && colors_good);

        //if (!(colors_good && geom_good)) {
        if (!geom_good) {
            //console.log("Points::make3d() exiting, because conditions on colors and geometry fail. geom_good=",geom_good,"colors_good=",colors_good);
            return;
        }
        

        clear();

        /////////////////////////////////
        var geometry = new THREE.BufferGeometry();
        geometry.addAttribute( 'position', new THREE.BufferAttribute( new Float32Array(positions), 3 ) );
        
            /*
        if (use_colors) {
            geometry.addAttribute( 'color', new THREE.BufferAttribute( new Float32Array(colors), 3 ) );
            //console.log("geometry added color attr");
        }
        */

        geometry.computeBoundingSphere();
        
        /////////////////////////////////
        
        //  мульти-материальная геометрия http://threejs.org/examples/webgl_geometry_colors.html
        
        //var material = new THREE.MeshBasicMaterial( { color: 0x00ffff } );
        
        var c = somethingToColor( color );
        
        var materialOptions = {
            color: c, size: radius
        }
        
        //materialOptions.vertexColors = THREE.VertexColors;
        /*
        
        if (use_colors) 
            materialOptions.vertexColors = THREE.VertexColors;
        else
            materialOptions.color = c;
        */
            
            
        if (opacity < 1) {
            materialOptions.transparent = true;
            materialOptions.opacity = opacity;
        }
        
        var material = new THREE.PointsMaterial( materialOptions );
          
        /////////////////////////////////
        this.sceneObject = new THREE.Points( geometry, material );
        this.sceneObject.visible = visible;
        this.sceneObject.sortParticles = true;

        colorsChanged();
        textureUrlChanged();
        transparentChanged();
        
        scene.add( this.sceneObject );

        make3dbase();
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
