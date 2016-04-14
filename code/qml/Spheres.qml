import QtQuick 1.1

SceneObject {
  id: spheres
  property var positions: source.positions
  //onCenterChanged: console.log("***")

  property var colors
  property var radius: 1
  property var radiuses: []
 
  property var nx: 16
  property var ny: 24
  property var wire
  property var wireon

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
    // title: parent.title + " -> trimesh"

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
        
        if (!spheres_positions) return;

        if (spheres_positions.length > 5000) {
          console.log("Spheres: degrading nx,ny to 4 because too many spheres");
          latitudeBands = 4;
          longitudeBands = 4;
        }
        
        ///////////////////////////////////
        // make etalon
        var etalon = [];
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
                //var u = 1- (longNumber / longitudeBands);
                //var v = latNumber / latitudeBands;
                //etalon.push([x,y,z,u,v]);
                etalon.push([x,y,z]);
            }
        }
        var etalon_length = etalon.length;

        var etalon_indices = [];
        for (var latNumber = 0; latNumber < latitudeBands; latNumber++) {
            for (var longNumber = 0; longNumber < longitudeBands; longNumber++) {
                var first = (latNumber * (longitudeBands + 1)) + longNumber;
                var second = first + longitudeBands + 1;
                etalon_indices.push(first + 1);
                etalon_indices.push(second + 1);
                etalon_indices.push(second);
                etalon_indices.push(first + 1);
                etalon_indices.push(second);
                etalon_indices.push(first);
            }
        }
        var etalon_indices_length = etalon_indices.length;
        
        /////////////////////////////////////////////
        /// replicate

        for (var i=0, qq=0; i<spheres_positions.length; i+=3,qq++) {
          var xx = spheres_positions[i+0];
          var yy = spheres_positions[i+1];
          var zz = spheres_positions[i+2];
          
          //var radius2 = spheres.radiuses && spheres.radiuses.length > qq ? spheres.radiuses[qq] : spheres.radius;
          var radius2 = spheres_radiuses && spheres_radiuses.length > qq ? spheres_radiuses[qq] : rr;
          // console.log(spheres.radiuses && spheres.radiuses.length,radius2,qq);

          var istart = positions.length /3;

          for (var e=0; e<etalon_length; e++) {
            var ee = etalon[e];

                normals.push(ee[0]);
                normals.push(ee[1]);
                normals.push(ee[2]);
                //uvs.push(ee[3]);
                //uvs.push(ee[4]);
                
                positions.push(radius2 * ee[0]+xx);
                positions.push(radius2 * ee[1]+yy);
                positions.push(radius2 * ee[2]+zz);

             if (spheres_colors) {
                  colors.push( spheres_colors[3*i/3] ); 
                  colors.push( spheres_colors[3*i/3+1] ); 
                  colors.push( spheres_colors[3*i/3+2] ); 
                  if ($driver.colors == 4)
                    colors.push( spheres_colors[4*i/3+3] );
             }
          }

          for (var u=0; u<etalon_indices_length; u++) 
            indices.push( etalon_indices[u] + istart );
        
        } // for var i



        //console.log([ positions, normals, uvs, indices, colors ]);
        // console.log("spheres complete ******************* spheres.positions.length=",spheres.positions.length, " generated positions.length=",positions.length);
        return [ positions, normals, uvs, indices, colors ];
    }

    
    positions: geom ? geom[0] : []
    indices: geom ? geom[3] : []
    color: spheres.color
    colors: geom ? geom[4] : []
    normals: geom ? geom[1] : []
    wire: spheres.wire
    wireon: spheres.wireon
    opacity: spheres.opacity
    visible: spheres.visible
    center: spheres.center
    rotate: spheres.rotate
    scale: spheres.scale
    renderOrder: spheres.renderOrder

    property var geom: make()
    
  }

}
