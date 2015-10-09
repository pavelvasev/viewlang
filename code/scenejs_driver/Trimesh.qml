Item {
    property var positions
    property var indices
    property var color
    property var colors
    property var wire
    property var normals

    property var priority: 0

    /////////////////// graphics part
    id: qmlObject

    onPositionsChanged: {
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

    onIndicesChanged: {
        makeLater( this );
        /*
        if (!this.sceneObject) return;
        if (indices)
  				this.sceneObject.geometry.addAttribute( 'index', new THREE.BufferAttribute( new Uint32Array(indices), 3 ) );

        var attr = this.sceneObject.geometry.getAttribute("index");
        //attr.set( new Uint32Array(indices) ); 
        attr.needsUpdate = true;
        */
    }
    
    onColorsChanged: {
        makeLater(this);
        /*
        if (qmlObject.sceneJsRootNode && qmlObject.sceneJsGeometryNode.getColors() && qmlObject.sceneJsGeometryNode.getColors().length == qmlObject.colors.length)
            qmlObject.sceneJsGeometryNode.setColors( { colors: qmlObject.colors } );
        else
            makeLater( qmlObject );
        */
    }

  
    onWireChanged: {
       makeLater(this);
    /*
        if (!qmlObject.sceneJsRootNode) { makeLater( qmlObject ); return; };
        qmlObject.sceneJsGeometryNode.setPrimitive( { primitive: qmlObject.wire ? "lines" : "triangles" } );
    */
    }
/*
    onOpacityChanged: {
        if (!qmlObject.sceneJsRootNode) { makeLater( qmlObject ); return; };
        qmlObject.sceneJsMaterialNode.setAlpha( qmlObject.visible ? qmlObject.opacity : 0 );
    }

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
        var colors_good = (qmlObject.colors && qmlObject.positions && qmlObject.colors.length > 0) ? qmlObject.positions.length/3 == qmlObject.colors.length/4 : true;
        var geom_good = (qmlObject.positions && qmlObject.positions.length > 0 && qmlObject.indices && qmlObject.indices.length >= 0);

        console.log( "creator-trimesh, colors_good = ",colors_good, " geom_good=",geom_good,"qmlObject.positions.length/3=",qmlObject.positions.length/3,"qmlObject.colors.length/4=",qmlObject.colors.length/4 );

        if (qmlObject.sceneJsRootNode) qmlObject.sceneJsRootNode.destroy();
        qmlObject.sceneJsRootNode = null;

        if (colors_good && geom_good) {

            qmlObject.sceneJsRootNode = qmlObject.sceneJsOpacityNode = scene.mainContent.addNode( { type: "flags", flags:{ transparent:true, backfaces:true } } );

            qmlObject.sceneJsPriorityNode = qmlObject.sceneJsOpacityNode.addNode( { type:"layer", priority:0 } );

            qmlObject.sceneJsMaterialNode = qmlObject.sceneJsPriorityNode.addNode({
                                                                                      type: "material",
                                                                                      color: qmlObject.color ? { r: qmlObject.color[0], g: qmlObject.color[1], b: qmlObject.color[2] } : { r: 0.2, g: 0.2, b: 0.6 }
                                                                                  });

            // console.log( "instantiating geometry node! qmlObject.id=",qmlObject.id ); // qmlObject.normals.length = ",qmlObject.normals ? qmlObject.normals.length : -1 );

            qmlObject.sceneJsGeometryNode = qmlObject.sceneJsMaterialNode.addNode({
                                                                                      type: "geometry",
                                                                                      primitive: qmlObject.wire ? "lines" : "triangles",
                                                                                                                  positions: qmlObject.positions ? qmlObject.positions : [],
                                                                                                                                               //uv: uv.length > 0 ? uv : undefined,
                                                                                                                                               normals: qmlObject.normals && qmlObject.normals.length > 0 ? qmlObject.normals : "auto", // undefined, //
                                                                                                                                                                                                            indices: qmlObject.indices ? qmlObject.indices : [],
                                                                                                                                                                                                                                         colors: qmlObject.colors && qmlObject.colors.length > 0 ? qmlObject.colors : undefined
                                                                                      //                , normals:"auto"
                                                                                      // Automatically create normals - only works with 'triangles' primitive
                                                                                  });

        }
        else console.log("creating skipped, object is bad!");

        qmlObject.visibleChanged();
        qmlObject.priorityChanged();

    }

}
