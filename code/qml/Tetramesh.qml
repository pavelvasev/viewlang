SceneObject {

  id: origin
  property var positions: source.positions
  property var indices: source.indices
  property var colors: source.colors
  property var wire

  property var flat: false//true

  title: "Tetramesh"

  onPositionsChanged: {
    console.log("Tetramesh: checking new positions of tetramesh ",title );
           for (var i=0; i<positions.length; i++) { 
             if (typeof(positions[i]) === "undefined") { 
               console.log("Tetramesh: position val undefined! i=",i); 
             } 
            }
  }

  function setup( newpositions,newindices )
  {
    if (newpositions)
      positions = newpositions;
    if (newindices)
      indices = newindices;
    console.log("setup was called");
  }
  
  //////////////////////////////////
  
//  property var addTetra: addTetraQ
  
  /*
  function chainAddTetra( newFunc )
  {
    var old = addTetra;
    addTetra = newFunc;
    return old;
  }
  */

  function intersect (pos) {
    var r = tetras.intersect( pos );
    //console.log(" tetramesh r=",r);
    if (r == null) return;
    r.faceIndex = r.index;
    return r;
  }
  
  Tetras {
    id: tetras
    property var nesting: true

    //property var geom: make()

    color: origin.color
    
    wire: origin.wire
    priority: origin.priority
    opacity: origin.opacity
    visible: origin.visible	
    //shading: origin.shading

    materials: origin.materials
    flat: origin.flat
    
    Component.onCompleted: {
      //console.log("im inner tetra, origin.indices=",origin.indices);
    }

    positions: geom ? geom[0] : []
    colors: geom ? geom[1] : []

    property var geom: make()

    function append( tetrasCount, source, target, elemsize )
    {
        if (!source || source.length == 0) return;

        for (var i=0; i<tetrasCount; i++ ) {
          for (var k=0; k<4; k++ ) {
            for (var j=0; j<elemsize; j++) { 
              target.push( source[ elemsize*origin.indices[ 4*i+k ]+j ] );
              
              /* отладочный вариант*/
              /*
              var origIndex = origin.indices[ 4*i+k ];
              var indexinsource = elemsize*origIndex+j;
              var v = source[ indexinsource ];
              target.push( v ); // 
              
              if (typeof(v) === "undefined" || isNaN(v)) {
                console.log("got null value while performing append! tetranum i=",i," sidenum k=",k," elem item j=",j,"indexinsource=",indexinsource,"source.length=",source.length,
                            "origIndex=",origIndex,"4*i+k=",4*i+k,"origin.indices.length=",origin.indices.length);
                debugger;
              }
              */
              
            }
              
          } // k
        } // i
    }
    
    function make() 
    {
        
        var pos = [], cols = [];
        var res = [ pos,cols ];
        if (!origin.visual) return res;
        if (!origin.indices || !origin.indices.length) return res;
        var tetrasCount = origin.indices.length /4;
        var have_colors = origin.colors && origin.colors.length > 0;
        
        console.log("tetramesh->tetras make!");
        append( tetrasCount, origin.positions, pos, 3 );
        append( tetrasCount, origin.colors, cols, $driver.colors );
        // console.log("i made tetras");
        
        return res;
    } // make

  } // trimesh
  
}