Tetramesh {
  title: "TetrameshZFilter"

  property alias zParam: zParamA

  Param {
    id: zParamA
    title: "zmax"
    min:0
    max:100
    value: 100
    enableSliding: false
    onChanged: {
      value=newvalue;
      //makeLater(tetra);
    }
  }  
  
  id: origin
  visual: false
  
  indices: compute ? compute[0] : []
  property var originalTetraNumbers: compute ? compute[1] : []
  property var compute: filter( source.indices )
  
  function filter( ins ) {
            if (!ins.length) return [[],[]];

            var inlen = ins.length;
            var arr = [];
            var originalI = [];
            var z;
            var zmax = zParam.value+0.1;

            console.log("TetrameshZFilter.qml peforming job of calculating new indices.");
            
            // идем по тетраэдрам
            for (var i=0; i<inlen; i+=4)
            {
                // var z = (positions[ 3*ins[i]+2] + positions[ 3*ins[i+1]+2] + positions[ 3*ins[i+2]+2] + positions[ 3*ins[i+3]+2] )/4;
                z = positions[ 3*ins[i]+2];
                if (z > zmax) continue;
                /*
                z = positions[ 3*ins[i+1]+2];
                if (z > zmax) continue;
                z = positions[ 3*ins[i+2]+2];
                if (z > zmax) continue;
                z = positions[ 3*ins[i+3]+2];
                if (z > zmax) continue;                                                
                */
                
                // тетраэдр подошел? записываем его индексы
                arr.push( ins[i] );
                arr.push( ins[i+1] );
                arr.push( ins[i+2] );
                arr.push( ins[i+3] );
                originalI.push(Math.floor(i/4));
                // а как же аккумулятор из test14? сравнить!

                
                for (var k=0; k<4; k++)
                if (isNaN(ins[i+k])) {
                  console.log("TetrameshZFilter.qml: while pushing tetra i=",i," index item k=",k," i see the null value!");
                }
                
            }
            return [arr,originalI];
        }
}
