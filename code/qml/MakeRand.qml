Item {
  property var count: 1000
  property var radius: 100
  property var minus: 0

  property var output: makeRand( count, radius, minus )

  function makeRand( n,r,r0 ) {
      var acc = [];
      for (var i=0; i<n; i++) {
        acc.push( r*Math.random() -r0 ); //x
        acc.push( r*Math.random() -r0 ); //y
        acc.push( r*Math.random() -r0 ); //z
      }
      return acc;
  }
}