var Delaunay = require("./delaunay.js");
var Array2d  = require("array2d.js");

var DelaunayCaller = function() {

this.work = function(io)
{
  io.get( function(nodes) {
    var vertices = new Array(nodes.h);
    for (i=0; i<nodes.h; i++)
      vertices[i] = [ nodes.get(i,0), nodes.get(i,1) ];
    console.error("Triangulator got input array of h=",nodes.h);

    var triangles = Delaunay.triangulate(vertices);

    var n = Math.round( triangles.length / 3 );
    var result = new Array2d( n, 3 );

    for (i=0; i<triangles.length; i++)
      result.data[i] = triangles[i];

      io.set(".",result );
      io.finish();
  } );
}

}

module.exports = DelaunayCaller;
