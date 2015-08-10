Tetramesh {
  id: origin
  visual: false
  title: "TetrameshRotate"
  
  indices: rotate( source.indices )
  
  property alias calcCenters: calcCentersA
  TetrameshCenters {
    id: calcCentersA
    indices: source.indices
  }
  
  function rotate( ins ) {

            console.log( "rotate indices" );
            
            if (!ins.length) return [];
            var inlen = ins.length;
            var arr = [];

            console.log("rotate tetramesh goon, have n tetras = ",inlen/4);
            
            var changes=[0,0,0,0]

            var centers = [];
            var ccount=0;
            for (var i=0; i<inlen; i+=4,ccount+=3)
            {
                //var center = getCenter( ins[i], ins[i+1],ins[i+2],ins[i+3] );
                var center = [ calcCenters.positions[ccount],calcCenters.positions[ccount+1],calcCenters.positions[ccount+2] ];
                
                if (smotritNaCentr( ins[i],ins[i+1],ins[i+2],center )) {
                  var q = ins[i+1];
                  ins[i+1] = ins[i+2];
                  ins[i+2] = q;
                  changes[0]++;
                }
                
                /*
                if (smotritNaCentr( ins[i],ins[i+2],ins[i+3],center )) {
                  //console.log("replacing i=",i);
                  var q = ins[i+2];
                  ins[i+2] = ins[i+3];
                  ins[i+3] = q;
                  changes[1]++;
                }
                

                if (smotritNaCentr( ins[i],ins[i+3],ins[i+1],center )) {
                  var q = ins[i+3];
                  ins[i+3] = ins[i+1];
                  ins[i+1] = q;
                  changes[2]++;
                }
                

                if (smotritNaCentr( ins[i+1],ins[i+3],ins[i+2],center )) {
                  var q = ins[i+3];
                  ins[i+3] = ins[i+2];
                  ins[i+2] = q;
                  changes[3]++;
                }
                */
                
            }
            console.log("TetrameshRotate.qml : new trimesh indices len=",ins.length/4, " changes counters=",changes);
            
            return ins;
        }
  
        function getPos(i) {
            return [ positions[3*i], positions[1+3*i], positions[2+3*i] ];
        }

        function getDiff(i1,i2) {
            var p1 = getPos(i1);
            var p2 = getPos(i2);
            return [ p1[0]-p2[0], p1[1]-p2[1],p1[2]-p2[2] ];
        }

        function getCenter(i1,i2,i3,i4) {
            var p1 = getPos(i1);
            var p2 = getPos(i2);
            var p3 = getPos(i3);
            var p4 = getPos(i4);
            return [ (p1[0]+p2[0]+p3[0]+p4[0])/4, (p1[1]+p2[1]+p3[1]+p4[1])/4, (p1[2]+p2[2]+p3[2]+p4[2])/4  ];
        }

        // uses three.js
        function smotritNaCentr(i1,i2,i3,center) {
            var p1 = getPos( i1 );
            var d1 = getDiff( i2,i1 );
            var d2 = getDiff( i3,i1 );
            var cross = crossProduct(d1,d2);
            var p1tocenter = diff( center,p1 );
            
            // скалярное произведение между (векторным произведением d1,d2) и (вектором к центру)
            var dot = dotProduct( cross,p1tocenter );
            // то бишь это для нас знак между ними. положительный - значит вектора сонаправлены, треугольник перевернут

            // vector p2-p1, p3-p1
            var needReplace = dot>=0;
            return needReplace;

            //console.log(needReplace);
            if (needReplace)
                return [i1,i3,i2];
            else
                return [i1,i2,i3];
        }
      
}