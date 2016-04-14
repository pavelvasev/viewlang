// Вход - Trimesh
// Выход - Lines по его ребрам

Lines {
  id: tris

  property var trimeshPositions: source && source.positions ? source.positions : []
  property var trimeshIndices: source && source.indices ? source.indices : []

  function computeTriangles( positions, indices )
  {
      //return;
      var geom_good = (positions && positions.length > 0 && indices && indices.length >= 0);
      if (!geom_good) return [];
      var acc = [];

      var j;
      
      for (var i=0; i<indices.length; i+=3) {
        // треугольник значит
        j = indices[i]*3;
        acc.push( positions[ j ] );
        acc.push( positions[ j+1 ] );
        acc.push( positions[ j+2 ] );
        
        j = indices[i+1]*3;
        acc.push( positions[ j ] );
        acc.push( positions[ j+1 ] );
        acc.push( positions[ j+2 ] );

        //////////////////////// 1->2

        acc.push( positions[ j ] );
        acc.push( positions[ j+1 ] );
        acc.push( positions[ j+2 ] );

        j = indices[i+2]*3;
        acc.push( positions[ j ] );
        acc.push( positions[ j+1 ] );
        acc.push( positions[ j+2 ] );

        ///////////////////////// 2->0

        acc.push( positions[ j ] );
        acc.push( positions[ j+1 ] );
        acc.push( positions[ j+2 ] );

        j = indices[i]*3;
        acc.push( positions[ j ] );
        acc.push( positions[ j+1 ] );
        acc.push( positions[ j+2 ] );
      }
      
      return acc;
  }

  function make() {
    if (trimeshIndices && trimeshIndices.length > 0) {
      var res = computeTriangles( trimeshPositions, trimeshIndices )
      tris.positions = res;
    }
  }

  onTrimeshPositionsChanged: make()
  onTrimeshIndicesChanged: make()
  // TODO вообще это странно - пересчет при изменении параметров. Думать про ленивость?

  property var robotIcon: "="
}
