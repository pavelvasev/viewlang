Item {
  id: item

  property var source: parent
  property var positions: source && source.positions && source != item ? source.positions : []
  property var indices: source && source.indices && source != item ? source.indices : []
  property var enabled: true

  property alias input: item.positions

  property var mult: 1

  property var center: [0,0,0]
  property var sizes: [0,0,0]

  //onPositionsChanged: setTimeout( make, 10 );
  //onIndicesChanged: setTimeout( make, 10 );
  onPositionsChanged: make();
  onIndicesChanged: make();

  // TODO 1 Защита от рекурсий 2 Защита от повторных make 

  property int recursiveProtection: 0
  function make() {
    if (!enabled) return;

    if (item.recursiveProtection >= 1) {
      console.log("rec prot item.recursiveProtection=",item.recursiveProtection);
      return;
    }
    item.recursiveProtection = item.recursiveProtection + 1;

    var res = (indices && indices.length > 0) ? computeNormalsIndexed( positions, indices ) : computeNormalsNonIndexed( positions )
    if (res.length == 0) {
      item.recursiveProtection = item.recursiveProtection -1;
      return;
    }
    var sz = vDiff( res[1], res[0] );
    var sz2 = vMulScal( sz, 0.5 );
    var ct = vAdd( res[0], sz2 );

    center = ct;
    sizes = vMulScal( sz, mult );

    item.recursiveProtection = item.recursiveProtection -1;
  }

    function computeNormalsIndexed( positions, indices)
    {
      //return;
      var geom_good = (positions && positions.length > 0 && indices && indices.length >= 0);
      if (!geom_good) return [];

      var norms = [];
      norms.length = indices.length;
      var j;
      var min = [ 100000, 100000, 100000 ];
      var max = [ -100000, -100000, -100000 ];

      for (var i=0; i<indices.length; i++) {
        // треугольник значит
        j = indices[i]*3;
        var p1 = [ positions[ j ],positions[ j+1 ],positions[ j+2 ] ];

        min[0] = Math.min( min[0], p1[0] );
        min[1] = Math.min( min[1], p1[1] );
        min[2] = Math.min( min[2], p1[2] );

        max[0] = Math.max( max[0], p1[0] );
        max[1] = Math.max( max[1], p1[1] );
        max[2] = Math.max( max[2], p1[2] );
      }
      
      return [ min, max ];
    }

    function computeNormalsNonIndexed( positions )
    {
      //return;
      var geom_good = (positions && positions.length > 0);
      if (!geom_good) return [];

      var norms = [];
      norms.length = indices.length;
      var j;
      var min = [ 100000, 100000, 100000 ];
      var max = [ -100000, -100000, -100000 ];

      for (var j=0; j<positions.length; j+=3) {
        // треугольник значит
        var p1 = [ positions[ j ],positions[ j+1 ],positions[ j+2 ] ];

        min[0] = Math.min( min[0], p1[0] );
        min[1] = Math.min( min[1], p1[1] );
        min[2] = Math.min( min[2], p1[2] );

        max[0] = Math.max( max[0], p1[0] );
        max[1] = Math.max( max[1], p1[1] );
        max[2] = Math.max( max[2], p1[2] );
      }
      
      return [ min, max ];
    }

}
