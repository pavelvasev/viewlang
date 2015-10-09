SceneObject {
  id: origin
  visual: false
  
  property var spos: source.positions
  property var positions: getcenters( source.indices )
  
  function getcenters( ins,poss ) {
            if (!ins.length) return [];
            var inlen = ins.length;
            console.log("calc of centers started");

            var centers = [];
            for (var i=0; i<inlen; i+=4)
            {
                var center = getCenter( ins[i], ins[i+1],ins[i+2],ins[i+3] );
                centers.push( center[0] );
                centers.push( center[1] );
                centers.push( center[2] );
            }
            return centers;
        }
  
        function getPos(i) {
            return [ spos[3*i], spos[1+3*i], spos[2+3*i] ];
        }

        function getCenter(i1,i2,i3,i4) {
            var p1 = getPos(i1);
            var p2 = getPos(i2);
            var p3 = getPos(i3);
            var p4 = getPos(i4);
            return [ (p1[0]+p2[0]+p3[0]+p4[0])/4, (p1[1]+p2[1]+p3[1]+p4[1])/4, (p1[2]+p2[2]+p3[2]+p4[2])/4  ];
        }

}