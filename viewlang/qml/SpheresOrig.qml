import QtQuick 1.1

SceneObject {
  id: spheres
  property var positions

  property var colors
  property var radius: 1
  property var radiuses: []
 
  property var nx: 8
  property var ny: 8
  property var wire

  title: "Spheres"

  function intersect (pos) {
    var r = trimesh.intersect( pos );
    console.log(" spheres intersect r=",r);

    if (!r) return r;
    
    //var trisInSphere = nx*ny; //trimesh.positions.length / spheres.positions.length;
    var trisInSphere = trimesh.indices.length / spheres.positions.length;
    r.index = Math.floor( r.faceIndex / trisInSphere );
    console.log("trisInSphere=",trisInSphere," spheres found index =",r.index);
    
    return r;
  }  


  property alias atrimesh: trimesh
  Trimesh {
    property var nesting: true
    id: trimesh

    function make() 
    {
        //console.log("making trimesh for spheres, spheres.positions.length=",spheres.positions.length);

        var latitudeBands = nx;
        var longitudeBands = ny;
        
        var positions = [];
        var normals = [];
        var uvs = [];
        var indices = [];
        var colors = [];
        
        var spheres_colors = spheres.colors;
        var spheres_positions = spheres.positions;
        var spheres_radiuses = spheres.radiuses;
        var rr = spheres.radius;

        if (spheres_positions.length > 5000) {
          console.log("Spheres: degrading nx,ny to 4 because too many spheres");
          latitudeBands = 4;
          longitudeBands = 4;
        }

        for (var i=0, qq=0; i<spheres_positions.length; i+=3,qq++) {
          var xx = spheres_positions[i+0];
          var yy = spheres_positions[i+1];
          var zz = spheres_positions[i+2];
          
          //var radius2 = spheres.radiuses && spheres.radiuses.length > qq ? spheres.radiuses[qq] : spheres.radius;
          var radius2 = spheres_radiuses && spheres_radiuses.length > qq ? spheres_radiuses[qq] : rr;
          // console.log(spheres.radiuses && spheres.radiuses.length,radius2,qq);

          var istart = positions.length /3;

          
        for (var latNumber = 0; latNumber <= latitudeBands; latNumber++) {
            var theta = latNumber * Math.PI / latitudeBands;
            var sinTheta = Math.sin(theta);
            var cosTheta = Math.cos(theta);

            for (var longNumber = 0; longNumber <= longitudeBands; longNumber++) {
                var phi = longNumber * 2 * Math.PI / longitudeBands;
                var sinPhi = Math.sin(phi);
                var cosPhi = Math.cos(phi);

                var x = cosPhi * sinTheta;
                var y = cosTheta;
                var z = sinPhi * sinTheta;
                var u = 1- (longNumber / longitudeBands);
                var v = latNumber / latitudeBands;

                normals.push(x);
                normals.push(y);
                normals.push(z);
                uvs.push(u);
                uvs.push(v);
                
                positions.push(radius2 * x+xx);
                positions.push(radius2 * y+yy);
                positions.push(radius2 * z+zz);

                if (spheres_colors) {
                  colors.push( spheres_colors[3*i/3] ); 
                  colors.push( spheres_colors[3*i/3+1] ); 
                  colors.push( spheres_colors[3*i/3+2] ); 
                  if ($driver.colors == 4)
                    colors.push( spheres_colors[4*i/3+3] );
                }
            }
        }
        
        for (var latNumber = 0; latNumber < latitudeBands; latNumber++) {
            for (var longNumber = 0; longNumber < longitudeBands; longNumber++) {
                var first = (latNumber * (longitudeBands + 1)) + longNumber;
                var second = first + longitudeBands + 1;
                first += istart;
                second += istart;
                indices.push(first + 1);
                indices.push(second + 1);
                indices.push(second);
                indices.push(first + 1);
                indices.push(second);
                indices.push(first);
            }
        }
        
        } // for var i



        // console.log([ positions, normals, uvs, indices, colors ]);
        //console.log("dome",positions );
        return [ positions, normals, uvs, indices, colors ];
    }

    
    positions: geom ? geom[0] : []
    indices: geom ? geom[3] : []
    color: spheres.color
    colors: geom ? geom[4] : []
    normals: geom ? geom[1] : []
    wire: spheres.wire
    opacity: spheres.opacity
    visible: spheres.visible
    center: spheres.center

    property var geom: make()
    
  }

}
