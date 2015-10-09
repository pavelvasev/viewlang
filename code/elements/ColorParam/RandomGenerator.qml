Item {
  id: gen
  property var count: 100*3
  property var radius: 100
  property var delta: 0

  property var property: "positions"
  property var source: parent
  property alias target: gen.source

  onCountChanged: make()
  onRadiusChanged: make()
  onDeltaChanged: make()
  
  function make() {
    if (!target) return;
    target[property] = makeRand( count,radius,delta )
  }

  function makeRand( n,r,r0 ) {
   //console.log("r0=",r0);
      var acc = [];
      for (var i=0; i<n; i++) {
        acc.push( r*Math.random() -r0 ); //x
        acc.push( r*Math.random() -r0 ); //y
        acc.push( r*Math.random() -r0 ); //z
      }
      return acc;
  }
}  