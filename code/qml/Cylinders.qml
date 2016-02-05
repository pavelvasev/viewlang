SceneObject {

  title: "Cylinders"
  id: origin

  property var positions: source && source.positions ? source.positions : []
  property var colors: source && source.colors ? source.colors : []
  property var nx: source && source.nx && source.nx > 3 ? source.nx : 5
  property var radius: source && source.radius ? source.radius : 1

  property var ratio: null

  Trimesh {
    id: tris

    nesting: true

    positions: []
    indices: []
    colors: []
    
    wire: origin.wire
    opacity: origin.opacity
    color: origin.color
    visible: origin.visible

    materials: origin.materials
  }

  // see https://bitbucket.org/pavelvasev/scheme2/src/tip/scheme2go/libs/suffixes/trimesher/meshcreator.cs?at=default&fileviewer=file-view-default
  // aka 
  function makeCylinders( radius, nx, positions, colors, endRatio ) {
    var circle = [];
    var delta = 2.0 * Math.PI / nx;

    // cache
    for (var i=0; i<=nx; i++) {
      var alpha = i*delta;
      u1 = radius*Math.cos(alpha);
      w1 = radius*Math.sin(alpha);
      circle.push( [ u1,w1 ] );
    }

    var inds = [];
    var poss = [];
    var cols = [];

    // vertices
    var conesCount = positions.length / 6;
    // debugger;

    for (var q=0; q<conesCount; q++) {
      var s1 = 2*3*q;
      var s2 = s1+3;
      var p1 = [ positions[s1], positions[s1+1], positions[s1+2] ];
      var p2 = [ positions[s2], positions[s2+1], positions[s2+2] ];

      // Преобразуем p2 к доле endRatio
      if (endRatio)
        p2 = vLerp( p1, p2, endRatio );

      var basis = vBasis( p1, p2 );

      var color = null;
      if (colors) {
        var y1 = 3*q;
        color = [ colors[ y1 ],colors[ y1+1 ], colors[ y1+2 ] ]
      }

      var startIndex = poss.length / 3;

      for (var i=0; i<=nx; i++) {
        //coord[i, 0] = p1 + u1*v2 + w1*v3;
        //coord[i, 1] = p2 + u2*v2 + w2*v3;

        var u1 = circle[i][0];
        var w1 = circle[i][1];
        var dd = vAdd( vMulScal( basis[1], u1 ), vMulScal( basis[2], w1 ) );
        var nv1 = vAdd( p1, dd );
        var nv2 = vAdd( p2, dd );
        poss.push( nv1[0] ); poss.push( nv1[1] ); poss.push( nv1[2] );
        poss.push( nv2[0] ); poss.push( nv2[1] ); poss.push( nv2[2] );

        if (color) {
          cols.push( color[0] ); cols.push( color[1] ); cols.push( color[2] );
          cols.push( color[0] ); cols.push( color[1] ); cols.push( color[2] );
        }
      }
      
      // indices
      for (var i=0; i<nx; i++) {
         var j = 2*i;
         inds.push( startIndex + j );
         inds.push( startIndex + j+1 );
         inds.push( startIndex + j+3 );

         inds.push( startIndex + j );
         inds.push( startIndex + j+3 );
         inds.push( startIndex + j+2 );
      }
    }

    return [ poss, inds, cols ];
  }

  function make() {
    if (!positions) return;
    
    var res = makeCylinders( radius, nx, positions, colors && colors.length > 0 ? colors : null, ratio );
//    console.log( "cyl pos len=",res[0].length );
//    console.log( "cyl idx len=",res[1].length );
    tris.colors = res[2];
    tris.positions = res[0];
//    console.log( res[1] );
//    console.log( res[0] );
    tris.indices = res[1]; 
  }

  onPositionsChanged: make()
  onNxChanged: make()
  onRadiusChanged: make();
  onRatioChanged: make();
  onColorsChanged: make()

}