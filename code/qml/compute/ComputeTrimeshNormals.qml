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

      var norms = [];
      norms.length = indices.length;
      var j;
      
      for (var i=0; i<indices.length; i+=3) {
        // треугольник значит
        j = indices[i]*3;
        var p1 = [ positions[ j ],positions[ j+1 ],positions[ j+2 ] ];
        j = indices[i+1]*3;
        var p2 = [ positions[ j ],positions[ j+1 ],positions[ j+2 ] ];
        j = indices[i+2]*3;
        var p3 = [ positions[ j ],positions[ j+1 ],positions[ j+2 ] ];

        var d1 = diff(p2,p1);
        var d2 = diff(p3,p1);

        var norm = crossProduct( d1,d2 );
        norms[i]=norm[0];
        norms[i+1]=norm[1];
        norms[i+2]=norm[2];
      }
      
      return norms;
    }

    function computeNormalsNonIndexed( positions )
    {
      
      var geom_good = positions && positions.length > 0;
      if (!geom_good) return [];
      
      var norms = [];
      norms.length = positions.length/3;
      var j=0;
      var i=0;

      for (; j<positions.length; j+=3, i+=3) {
        // треугольник значит
        var p1 = [ positions[ j ],positions[ j+1 ],positions[ j+2 ] ];
        j+=3;
        var p2 = [ positions[ j ],positions[ j+1 ],positions[ j+2 ] ];
        j+=3;
        var p3 = [ positions[ j ],positions[ j+1 ],positions[ j+2 ] ];
        //console.log(p1,p2,p3);

        var d1 = diff(p2,p1);
        var d2 = diff(p3,p1);

        var norm = crossProduct( d1,d2 );
        norms[i]=norm[0];
        norms[i+1]=norm[1];
        norms[i+2]=norm[2];
      }

      return norms;
    }

}
