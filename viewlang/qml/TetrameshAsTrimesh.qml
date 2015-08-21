SceneObject {

  id: origin
  property var positions: source.positions
  property var indices: source.indices
  property var colors: source.colors
  property var wire
  property var wireon: false

  property var flat: true

  title: "Tetramesh"

  function setup( newpositions,newindices )
  {
    if (newpositions)
      positions = newpositions;
    if (newindices)
      indices = newindices;
  }

  function intersect (pos) {
    var r = trimesh.intersect( pos );
    console.log(" trimesh r=",r);
    if (r == null) return;
    // r.faceIndex - номер треугольника пересечения
    r.faceIndex = Math.floor( r.faceIndex / 4 ); // у нас по 4 треугольника в тетраэдре, сообразно вычисляется номер

    return r; 
  }


  //////////////////////////////////
  
  property var addTetra: addTetraQ
  
  /*
  function chainAddTetra( newFunc )
  {
    var old = addTetra;
    addTetra = newFunc;
    return old;
  }
  */

  function addTetraQ( i, accum )
  {
      if (i < 0) return;

      var arr = accum.arr;
 
          arr.push( origin.indices[i] );
          arr.push( origin.indices[i+1] );
          arr.push( origin.indices[i+2] );
          
          arr.push( origin.indices[i] );
          arr.push( origin.indices[i+2] );
          arr.push( origin.indices[i+3] );

          arr.push( origin.indices[i] );
          arr.push( origin.indices[i+3] );
          arr.push( origin.indices[i+1] );

          arr.push( origin.indices[i+1] );
          arr.push( origin.indices[i+3] );
          arr.push( origin.indices[i+2] );

  }
  
  Trimesh {
    id: trimesh
    property var nesting: true
    
    materials: origin.materials
    //property var flat: origin.flat
    wireon: origin.wireon
    
    /*
    materials: [defaultMaterial1]

    PhongMaterial {
      id: defaultMaterial1
      shading: 1
    }
    */

    //normals: []
    
    //property var geom: make()
    
    positions: origin.positions
    color: origin.color
    colors: origin.colors
    wire: origin.wire
    priority: origin.priority
    opacity: origin.opacity
    visible: origin.visible
    //shading: origin.shading
    
    indices: make()

    function make() 
    {
        if (!origin.visual) return [];
        //console.log( "make tetramesh -> trimesh indices. origin.positions.length=",origin.positions.length, " origin.indices.length =",origin.indices.length);

        if (!origin.indices || !origin.indices.length) return;
        var inlen = origin.indices.length;
        console.log("Tetramesh.qml make() going on, inlen=",inlen);
        
        var accum = { arr: [] };
        addTetra( -1,accum );
        for (var i=0; i<inlen; i+=4)
          addTetra( i,accum );
        addTetra( -2,accum );

        console.log("Tetramesh.qml make() finish. New trimesh indices len=",accum.arr.length);
        return accum.arr;
    } // make

  } // trimesh
  
}