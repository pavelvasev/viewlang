// brother of Cylinders
SceneObject {
    title: "Boxes"

    id: origin
    property var positions: source && source.positions ? source.positions: []
    property var colors: source && source.colors ? source.colors:[]
    property var nx: source && source.nx ? source.nx : 1
    property var ny: source && source.ny ? source.ny : 1
    property var nz: source && source.nz ? source.nz : 1
    property var radius: source && source.radius ? source && source.radius: 1
    property var wire: false

    // тройки высота, ширина, длина
    property var sizes: source && source.sizes ? source.sizes: []

    property var sides: 1|2|4

    property alias trimesh: tris

    Trimesh {
        id: tris

        nesting: true

        positions: []
        indices: []
        colors: []

        wire: origin.wire

        opacity: origin.opacity
        color: origin.color
        visible: origin.visible

        materials: origin.materials
    }


    function makeBoxes( radius, nx, ny, nz, positions, colors, sizes,sides ) {

        var circle = [];
        var delta = 2.0 * Math.PI / nx;

        var inds = [];
        var poss = [];
        var cols = [];

        // vertices
        var itemsCount = positions.length / 3;

        for (var q=0; q<itemsCount; q++) {
            var s1 = 3*q;
            var p = [ positions[s1], positions[s1+1], positions[s1+2] ];

            var color = null;
            if (colors) {
                var y1 = 3*q;
                color = [ colors[ y1 ],colors[ y1+1 ], colors[ y1+2 ] ]
            }

            var bsize = sizes ? [ sizes[s1],sizes[s1 +1],sizes[s1+2] ] : [radius,radius,radius ];
            var b = vMulScal( bsize, 0.5 );

            var offset = poss.length / 3;

            var zz = p[2] - b[2];
            poss.push( p[0] - b[0] );
            poss.push( p[1] - b[1] );
            poss.push( zz );

            poss.push( p[0] + b[0] );
            poss.push( p[1] - b[1] );
            poss.push( zz );

            poss.push( p[0] + b[0] );
            poss.push( p[1] + b[1] );
            poss.push( zz );

            poss.push( p[0] - b[0] );
            poss.push( p[1] + b[1] );
            poss.push( zz );

            zz = p[2] + b[2];
            poss.push( p[0] - b[0] );
            poss.push( p[1] - b[1] );
            poss.push( zz );

            poss.push( p[0] + b[0] );
            poss.push( p[1] - b[1] );
            poss.push( zz );

            poss.push( p[0] + b[0] );
            poss.push( p[1] + b[1] );
            poss.push( zz );

            poss.push( p[0] - b[0] );
            poss.push( p[1] + b[1] );
            poss.push( zz );

            if (color) {
                cols.push( color[0] ); cols.push( color[1] ); cols.push( color[2] );
                cols.push( color[0] ); cols.push( color[1] ); cols.push( color[2] );
                cols.push( color[0] ); cols.push( color[1] ); cols.push( color[2] );
                cols.push( color[0] ); cols.push( color[1] ); cols.push( color[2] );

                cols.push( color[0] ); cols.push( color[1] ); cols.push( color[2] );
                cols.push( color[0] ); cols.push( color[1] ); cols.push( color[2] );
                cols.push( color[0] ); cols.push( color[1] ); cols.push( color[2] );
                cols.push( color[0] ); cols.push( color[1] ); cols.push( color[2] );
            }

            if (sides & 1) {
            // bottom
            inds.push( offset );
            inds.push( offset+2 );
            inds.push( offset+1 );

            inds.push( offset );
            inds.push( offset+3 );
            inds.push( offset+2 );

            // top
            inds.push( offset  +4 );
            inds.push( offset+1+4 );
            inds.push( offset+2+4 );

            inds.push( offset  +4 );
            inds.push( offset+2+4 );
            inds.push( offset+3+4 );
            }
	

	          if (sides & 2) {
            // near
            inds.push( offset );
            inds.push( offset+1 );
            inds.push( offset+5 );

            inds.push( offset );
            inds.push( offset+5 );
            inds.push( offset+4 );

            // far
            inds.push( offset  +3 );
            inds.push( offset+6 );
            inds.push( offset+2 );

            inds.push( offset  +3 );
            inds.push( offset+7 );
            inds.push( offset+6 );
            }

            ////////// 
            // left
            if (sides & 4) {
            inds.push( offset );
            inds.push( offset+7 );
            inds.push( offset+3 );

            inds.push( offset );
            inds.push( offset+4 );
            inds.push( offset+7 );

            // right
            inds.push( offset+1 );
            inds.push( offset+2 );
            inds.push( offset+6 );

            inds.push( offset+1 );
            inds.push( offset+6 );
            inds.push( offset+5 );
            }

        }

        return [ poss, inds, cols ];
    }

    function make() {
        if (!positions) return;
        //console.log( "positions=",positions);
        var res = makeBoxes( radius, nx, ny, nz, positions,
                        colors && colors.length > 0 ? colors : null,
                        sizes && sizes.length > 0 ? sizes : null, sides );

        tris.colors = res[2];
        tris.positions = res[0];
        tris.indices = res[1];
    }

    onPositionsChanged: make()
    onNxChanged: make()
    onNyChanged: make()
    onNzChanged: make()
    onRadiusChanged: make();
    onSizesChanged: make();
    onColorsChanged: make()

}
