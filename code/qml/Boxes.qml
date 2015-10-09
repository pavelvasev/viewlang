SceneObject {

  property var positions: source.positions
  property var colors: source.colors
  property var wire

  Lines {
    id: lines
  }

  function addline( acc, i1, i2, offset ) {
      acc.push( positions[3*i1 + 3*offset] );
      acc.push( positions[3*i1+1 + 3*offset] );
      acc.push( positions[3*i1+2 + 3*offset] );

      acc.push( positions[3*i2 + 3*offset] );
      acc.push( positions[3*i2+1 + 3*offset] );
      acc.push( positions[3*i2+2 + 3*offset] );
  }

  onPositionsChanged: {
    var acc = [];
    for (var i=0; i<positions.length; i+=8) {
      addline( acc, 
    }
  }
}