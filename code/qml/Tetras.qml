SceneObject {

  id: origin
  property var positions: source.positions
  property var colors: source.colors
  property var wire

  title: "Tetras"

  property var flat: true

  onPositionsChanged: {
    console.log("Tetras: checking new positions of tetras ",title, origin.parent ? origin.parent.title : "" );
           for (var i=0; i<positions.length; i++) { 
             if (typeof(positions[i]) === "undefined") { 
               console.log("Tetras: position val undefined! i=",i); 
             } 
            }
  }  

  function intersect( pos ) {
    var r = tri.intersect( pos );
    //console.log("Tetras intersect=",r);
    if (!r) return null;
    r.index = Math.floor( r.index /4 );
    return r;
    
//    console.log(r);
//    return r;
  }

  Triangles {
    property var nesting: true
    id: tri

    property var geom: make()
    positions: geom ? geom[0] : []
    colors: geom? geom[1] : [];
    
    wire: origin.wire
    opacity: origin.opacity
    color: origin.color
    visible: origin.visible

    materials: origin.materials
    
    function razvernutVPloskoe( tetrasCount, sourcearr, targetarr, itemsInElement )
    {
      if (!sourcearr || sourcearr.length == 0) return [];
    
      var inlen = sourcearr.length;
      targetarr.length = tetrasCount *4 *3 *itemsInElement;
      // 4 треугольника на тетраэдр, 3 вершины в треугольнике, itemsInElement координаты в вершине (3 для xyz, 2 для uv, 3 или 4 для цвета)

      var sides = [ [0,itemsInElement*1,itemsInElement*2], [0,itemsInElement*3,itemsInElement*1], 
                    [0,itemsInElement*2,itemsInElement*3], [itemsInElement*1,itemsInElement*3,itemsInElement*2] ];
      
      var sourceStep = 4*itemsInElement;  // 4 вершины на тетраэдр, в каждой по itemsInElement значения
      for (var i=0, j=0; i<inlen; i+= sourceStep )
      {
        for (var k=0; k<4; k++) {
          var side = sides[k];
          //console.log(side);
          
          // формируем треугольник номер k

          // данные первой вершины
          for (var u=0; u<itemsInElement; u++) 
            targetarr[ j++ ] = sourcearr[ i + side[0]+u ];

          // данные второй вершины  
          for (var u=0; u<itemsInElement; u++) 
            targetarr[ j++ ] = sourcearr[ i + side[1]+u ];

          // данные третьей вершины    
          for (var u=0; u<itemsInElement; u++) 
            targetarr[ j++ ] = sourcearr[ i + side[2]+u ];            

        } // k,side
      } // for i      

    } // razvernutVPloskoe

    function make() 
    {
      //console.log("tetras->triangles make called, colors=",origin.colors); 

      var tetrasCount = origin.positions.length/(4*3); // 4 вершины на тетраэдр, в каждой по 3 значения (x,y,z)
      
      var tripos = [], tricols = [];
      //var res = { positions: tripos, colors: tricols };
      var res = [tripos,tricols];
      if (!origin.visual) return res;

      razvernutVPloskoe( tetrasCount, origin.positions, tripos, 3 );
      razvernutVPloskoe( tetrasCount, origin.colors, tricols, $driver.colors );
      
      // console.log(" i computed res=",res);

      return res;
    } // make

  } // triangles
}