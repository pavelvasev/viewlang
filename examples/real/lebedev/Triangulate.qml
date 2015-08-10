Item {
  property var input
  property var output: calc()
  property var deLoaded: false

  function calc() {
    if (!deLoaded) return []; 
    
    var vertices = new Array(Math.round(input.length/3));
    for (var i=0; i<vertices.length; i++)
      vertices[i] = [ input[3*i], input[3*i+1] ];
    
    var triangles = Delaunay.triangulate(vertices);
    return triangles;
  }

  Component.onCompleted: {
//    debugger;
    la_require( $basePath + "delaunay.js", function() { deLoaded = true; } );
  }
}