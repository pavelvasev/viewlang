Item {
  property var source: parent
  property var positions: source && source.positions ? source.positions : []
  property var indices: source && source.indices ? source.indices : []

  // normals
  property var output: indices && indices.length > 0 ? computeNormalsIndexed( positions, indices ) : computeNormalsNonIndexed( positions )

    function computeNormalsIndexed( positions, indices)
    {
      //return;
      var geom_good = (positions && positions.length > 0 && indices && indices.length >= 0);
      if (!geom_good) return [];

      var acc = [];
      var j;
      
      for (var i=0; i<indices.length; i+=3) {
        // треугольник значит
        j = indices[i]*3;
        var p1 = [ positions[ j ],positions[ j+1 ],positions[ j+2 ] ];
        j = indices[i+1]*3;
        var p2 = [ positions[ j ],positions[ j+1 ],positions[ j+2 ] ];
        j = indices[i+2]*3;
        var p3 = [ positions[ j ],positions[ j+1 ],positions[ j+2 ] ];

        acc.push( (p1[0] + p2[0] + p3[0]) / 3.0 );
        acc.push( (p1[1] + p2[1] + p3[1]) / 3.0 );
        acc.push( (p1[2] + p2[2] + p3[2]) / 3.0 );
      }
      
      return acc;
    }

    function computeNormalsNonIndexed( positions )
    {

      var geom_good = positions && positions.length > 0;
      if (!geom_good) return [];

      var acc = [];
      var j,i;

      for (var j=0; j<positions.length; j+=3, i+=3) {
        // треугольник значит
        var p1 = [ positions[ j ],positions[ j+1 ],positions[ j+2 ] ];
        j+=3;
        var p2 = [ positions[ j ],positions[ j+1 ],positions[ j+2 ] ];
        j+=3;
        var p3 = [ positions[ j ],positions[ j+1 ],positions[ j+2 ] ];

        acc.push( (p1[0] + p2[0] + p3[0]) / 3.0 );
        acc.push( (p1[1] + p2[1] + p3[1]) / 3.0 );
        acc.push( (p1[2] + p2[2] + p3[2]) / 3.0 );
      }

      return acc;
    }

}
