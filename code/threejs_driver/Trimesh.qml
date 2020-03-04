SceneObjectThreeJs {
    property var positions
    property var indices
    property var color
    property var colors // по вершинам (не по индексам)
    property var wire
    property var normals

    property bool wireon: false
    
    property var noIndices: (!indices || indices.length == 0) // индексы отныне необязательно, 2020-02-15

    signal click( object info );
    signal doubleClick( object info );
    
    materials: [defaultMaterial1]

    PhongMaterial {
      id: defaultMaterial1
    }

    title: "Trimesh"

    /////////////////// graphics part
    id: qmlObject
    
	onWireonChanged: {
	    if (!this.sceneObject) return;
	    if (wireon) {
  	      if (!qmlObject.wireframe) {
		  	qmlObject.wireframe = new THREE.WireframeHelper( this.sceneObject, 0xbf00 );
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
        
        var attr = this.sceneObject.geometry.getAttribute("position");
        if (!attr) return makeLater(this);
        
        // кажется что это медленнее
        // похоже проблема в том что мы тут все копируем по первому чиху
        // а makeLater делает все отложенно
        // таким образом делает это в рендеринге, когда устаканилось, и если было несколько изменений, то зафиксируется только 1
        // то есть нам чтобы делать все хорошо, надо еще updateLatr ввести

        var space_in_attr = attr.count*3; // attr.count это кол-во вершнин, а не флоатов
        if (positions.length <= space_in_attr && positions.length >= space_in_attr/4 ) { 
           // если есть место -- то скопируем
           // но если теперь надо в X раз меньше, переделаем все
           //console.log("i going to copy" );
           makeLater( this, "positions", function() {
             attr.set( new Float32Array(positions) );
             attr.needsUpdate = true; 
             //console.log("i copy" );
           } );
           
        }
        else {
          makeLater( this );
          //console.log("i rebuild",positions.length,attr.count);
        }
    }

    property var uvs: []
    function setuv() {
      // todo 1) убрать двойное копирование 2) удаление
      if (!this.sceneObject) return makeLater(this);
      if (uvs.length == 0) return;

      var attr = this.sceneObject.geometry.getAttribute("uv");
      if (!attr)
        this.sceneObject.geometry.setAttribute( 'uv', new THREE.BufferAttribute( new Float32Array(uvs), 2 ) );
      else {
        attr.set( new Float32Array(uvs) );             
        attr.needsUpdate = true; 
      }
    }
    onUvsChanged: setuv()

    onIndicesChanged: {
        makeLater( this );
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
          this.sceneObject.geometry.setAttribute( 'color', new THREE.BufferAttribute( new Float32Array(colors), 3 ) );
        }
    }


    function make3d()
    {
        //console.log("trimesh make3d called. this._uniqueId=",this._uniqueId,"parent.dom=",parent.dom);
        console.log("trimesh make3d called. this._uniqueId=",this._uniqueId,"positions.length=",positions ? positions.length : -1, "indices.length=",indices ? indices.length : -1, "noIndices=",noIndices);
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

        if (indices) {
            //console.log("indices assigned");
            geometry.setIndex( new THREE.BufferAttribute( new Uint32Array(indices), 1 ) );
        }
        else {
            //console.log("no indices assigned" );
        }

        if (positions)
            geometry.setAttribute( 'position', new THREE.BufferAttribute( new Float32Array(positions), 3 ) );

                
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
           console.log("make3d: normal attr set, len=",normals.length);
           geometry.setAttribute( 'normal', new THREE.BufferAttribute( new Float32Array(normals), 3 ) );
        }
        else {
           //console.log("so material.shading == 2",material.shading == 2);
            //geometry.computeFaceNormals();
            // computeVertexNormals это нормально, в BufferedGeometry оно делает что надо
            // да блин, это вершинные, а нам надо - фейсовые
            
            //if (!flat) { // нормали нам не нужны, если мы во flat-режиме
            if (!material.flatShading) {
              // вершинные нормали
               console.log("make3d: computing vertex normals using threejs");
              // debugger;
              geometry.computeVertexNormals();
            }
        }
        
        geometry.computeBoundingSphere();
        
        /////////////////////////////////


        this.sceneObject = new THREE.Mesh( geometry, material );

        colorsChanged();
        wireonChanged();
        setuv();

        scene.add( this.sceneObject );

        //console.log( "oname=",__executionContext.nameForObject(this) );
        //console.log( "oname=",this.title );
        make3dbase();

        //make3dfinished();
    }

    //signal make3dfinished();

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
      //console.log( "clear called for trimesh...",this); 
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
