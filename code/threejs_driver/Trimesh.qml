SceneObjectThreeJs {
    property var positions
    property var indices
    property var color
    property var colors
    property var wire
    property var normals

    property bool wireon: false

//    property var flat: false
    
//    property var shading: 2
    
    property var noIndices: false

    signal click( object info );
    signal doubleClick( object info );
    
    materials: [defaultMaterial1]

    PhongMaterial {
      id: defaultMaterial1
    }

    title: "Trimesh"

    /////////////////// graphics part
    id: qmlObject
    
    /* threejssceneobject
    function intersect( pos ) {
      if (!this.sceneObject) return null;
      
  	  raycaster.setFromCamera( pos, camera );
			var intersects = raycaster.intersectObject( this.sceneObject,false );
			// console.log("intersects=",intersects);
			if (intersects.length == 0) return null;

			var intersect = intersects[0];
			return intersect;
	  }
	  */

	onWireonChanged: {
	    if (!this.sceneObject) return;
	    if (wireon) {
  	      if (!qmlObject.wireframe) {
		  	qmlObject.wireframe = new THREE.WireframeHelper( this.sceneObject, 0xbf00 );
					//qmlObject.wireframe.material.depthTest = false;
					//qmlObject.wireframe.material.opacity = 0.55;
					//qmlObject.wireframe.material.transparent = true;		  	
			  scene.add( qmlObject.wireframe );	
		  }
		}
		else
		{
		   clearobj( this.wireframe ); this.wireframe = undefined;
		}
	}
    
  
    onPositionsChanged: {
        // если мы в безиндексном режиме - надо переделывать целиком
        if (!indices)
          makeLater(this);

//        console.log("trimesh onPositionsChanged");
        if (!this.sceneObject) return makeLater(this);
        
//        if (positions)
//          this.sceneObject.geometry.addAttribute( 'position', new THREE.BufferAttribute( new Float32Array(positions), 3 ) );

        var attr = this.sceneObject.geometry.getAttribute("position");
        if (!attr) return makeLater(this);
        
        // кажется что это медленнее
        // похоже проблема в том что мы тут все копируем по первому чиху
        // а makeLater делает все отложенно
        // таким образом делает это в рендеринге, когда устаканилось, и если было несколько изменений, то зафиксируется только 1
        // то есть нам чтобы делать все хорошо, надо еще updateLatr ввести

        if (positions.length <= attr.count && positions.length >= attr.count/4 ) { 
           // если есть место -- то скопируем
           // но если теперь надо в X раз меньше, переделаем все
           makeLater( this, "positions", function() {
             attr.set( new Float32Array(positions) );
             attr.needsUpdate = true; 
             //console.log("i copy" );
           } );
           
        }
        else {
          makeLater( this );
          //console.log("i rebuild");
        }
    }

    onIndicesChanged: {
        makeLater( this );
        

        //if (!this.sceneObject) return makeLater( this );

        /*
        

        if (indices)
                this.sceneObject.geometry.addAttribute( 'index', new THREE.BufferAttribute( new Uint32Array(indices), 3 ) );

        var attr = this.sceneObject.geometry.getAttribute("index");
        //attr.set( new Uint32Array(indices) );
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
        if (attr && attr.array.length >= colors.length) {
            attr.set( colors );
            attr.needsUpdate = true;
        } else {
          this.sceneObject.geometry.addAttribute( 'color', new THREE.BufferAttribute( new Float32Array(colors), 3 ) );
        }
    }

/* теперь в SceneObjectThreejs
    onVisibleChanged: {
        //makeLater(this);
        if (this.sceneObject)
          this.sceneObject.visible = visible;
    }    
*/    
    
   
    
    /*
    onWireChanged: {
      if (!this.sceneObject) return;
      this.sceneObject.material.wireframe = wire;
      this.sceneObject.material.needsUpdate = true;
    }
    */
    
    /*
    onShadingChanged: {
      makeLater( this );
      return;
      console.log("q");
      if (!this.sceneObject) return;
      console.log( shading );
      this.sceneObject.material.shading = (shading == 2 ? THREE.SmoothShading: (shading == 1 ? THREE.FlatShading : THREE.NoShading) );
      console.log(this.sceneObject.material.shading);
      this.sceneObject.material.needsUpdate = true;
    }
    */
    /*
    onOpacityChanged: {
        if (!this.sceneObject) return;
        this.sceneObject.material.opacity = opacity;
        this.sceneObject.material.needsUpdate = true;
    }*/

    /*
    
    onVisibleChanged: {
        if (!qmlObject.sceneJsRootNode) { makeLater( qmlObject ); return; };
        qmlObject.sceneJsMaterialNode.setAlpha( qmlObject.visible ? qmlObject.opacity : 0 );
    }

    onPriorityChanged: {
        if (!qmlObject.sceneJsRootNode) { makeLater( qmlObject ); return; };
        qmlObject.sceneJsPriorityNode.setPriority( qmlObject.priority );
    }
*/


    function make3d()
    {
        //console.log("trimesh make3d called. this._uniqueId=",this._uniqueId,"parent.dom=",parent.dom);
        //console.log("trimesh make3d called. this._uniqueId=",this._uniqueId,"positions.length=",positions ? positions.length : -1, "indices.length=",indices ? indices.length : -1, "noIndices=",noIndices);
        //console.trace();

        var colors_good = (colors && positions && colors.length > 0) ? positions.length/3 == colors.length/3 : true;
        var geom_good = (positions && positions.length > 0);
        
        // типа всегда должны быть индексы. окроме случая, когда указать режим noIndices
        if (!noIndices) geom_good = geom_good && (indices && indices.length > 0);
        
        if (!(colors_good && geom_good)) {
            console.log("Trimesh::make3d() exiting2, because conditions on colors and geometry fail. geom_good=",geom_good,"colors_good=",colors_good, "title=",title, positions ? positions.length: -1);
            //debugger;
            //console.log(positions);
            if (!geom_good) {
              console.log("i clear trimesh");
              clear();
            }
            return;
        }

        //console.log("i make trimesh");
        
        clear();

        /////////////////////////////////
        var geometry = new THREE.BufferGeometry();

        if (indices)
            geometry.addAttribute( 'index', new THREE.BufferAttribute( new Uint32Array(indices), 3 ) );

        if (positions)
            geometry.addAttribute( 'position', new THREE.BufferAttribute( new Float32Array(positions), 3 ) );

           /* 
        if (!normals || normals.length == 0)
          computeNormals();
          */

                
        //////////////////////////////////////////////////////
        //  мульти-материальная геометрия http://threejs.org/examples/webgl_geometry_colors.html
        
        // console.log(materials);
        if (!materials || materials.length == 0) materials = [defaultMaterial1];

        // console.log("@@@@@@@@@@@@@@@ shader = ",shader,this);
        var material = materials[0].makeMaterial( this );
        
        //var material = new THREE.MeshBasicMaterial( { color: 0x00ff00 } );

        //////////////////////////////////////////////////////
  
        // с нормалями хитровато. Если указан пустой массив - то мы не выставляем их и не рассчитываем
        //console.log("flat = ",flat);
        //debugger;
        if (normals && normals.length > 0) {
           geometry.addAttribute( 'normal', new THREE.BufferAttribute( new Float32Array(normals), 3 ) );
        }
        else {
           //console.log("so material.shading == 2",material.shading == 2);
            //geometry.computeFaceNormals();
            // computeVertexNormals это нормально, в BufferedGeometry оно делает что надо
            // да блин, это вершинные, а нам надо - фейсовые
            
            //if (!flat) { // нормали нам не нужны, если мы во flat-режиме
            if (material.shading == 2) {
            // вершинные нормали
            // console.log("computing threejs normals");
            // debugger;
            geometry.computeVertexNormals();
            }
        }
        
        geometry.computeBoundingSphere();
        
        /////////////////////////////////


        this.sceneObject = new THREE.Mesh( geometry, material );

        colorsChanged();
        wireonChanged();

        scene.add( this.sceneObject );


        //console.log( "oname=",__executionContext.nameForObject(this) );
        //console.log( "oname=",this.title );
        make3dbase();

        
       // console.log("this.sceneObject.on=",this.sceneObject.on);
       /* this.sceneObject.on('click', function(info) {
          console.log("hey click!",info );
        } );
        */
       
        
        /*
        try {
        scene.add( new THREE.VertexNormalsHelper( this.sceneObject ) );
        } catch(e) {
          console.log("helper error",e);
        }
        */

        //console.log("make3d complete, this.sceneObject=",this.sceneObject);
        //console.log("make3d complete, visible=",visible);
    }

    function computeNormals()
    {
      //return;
      var geom_good = (positions && positions.length > 0 && indices && indices.length >= 0);
      var norms = [];
      norms.length = indices.length;
      var j;
      
      for (var i=0; i<indices.length; i+=3) {
        // треугольник значит
        j = indices[i];
        var p1 = [ positions[ j ],positions[ j+1 ],positions[ j+2 ] ];
        j = indices[i+1];
        var p2 = [ positions[ j ],positions[ j+1 ],positions[ j+2 ] ];
        j = indices[i+2];
        var p3 = [ positions[ j ],positions[ j+1 ],positions[ j+2 ] ];

        var d1 = diff(p2,p1);
        var d2 = diff(p3,p1);

        var norm = crossProduct( d1,d2 );
        norms[i]=norm[0];
        norms[i+1]=norm[1];
        norms[i+2]=norm[2];
      }
      
      normals = norms;
    }

    function clear() {
      clearobj( this.sceneObject ); this.sceneObject = undefined;
      clearobj( this.wireframe ); this.wireframe = undefined;
    }

    function clearobj(obj) {
        if (obj) {
            // http://stackoverflow.com/questions/12945092/memory-leak-with-three-js-and-many-shapes
            // http://mrdoob.github.io/three.js/examples/webgl_test_memory.html
            scene.remove( obj );
            obj.geometry.dispose();
            // obj.material.dispose();
            if (obj.texture)
                obj.texture.dispose();
        }
    }

}
