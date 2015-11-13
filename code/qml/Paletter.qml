Item {
    // вход
    property var input // одномерный массив данных
    property var hivalue: undefined // какое значение "подсветить"

    //property alias file: palloader.file
    property var file: Qt.resolvedUrl("rainbow.rgb") // откуда брать палитру
    property var revert: false // повернуть цвета палитры задом-наперед

    property var useMin: null
    property var useMax: null

    onHivalueChanged: {
        console.log("hivalue=",hivalue);
    }

    // выход
    property var output: palette( input ) // цвета, в упаковке 1-мерный массив [r,g,b,r,g,b,...]

    property var minmax: arrminmax( input ); // вычисленное минимальное и макс. значения

    CsvLoader {
        file: parent.file
        skip: "#"
        id: palloader
        revert: parent.revert
    }

    property var pal: palloader.output
    //  property var pal: []

    ///////////////////// вычислительная часть

    function value2color( palette, v, min, max ) {
        var diff = max - min;

        if (palette.length > 0) {
            var n = Math.floor( (palette.length-1) * ((v - min)) / diff );
            if (isNaN(n)) {
                //debugger;
                return [1,0,0];
            }

            if (n < 0) n = 0;
            if (n >= palette.length) n = palette.length-1;

            return [palette[n][0], palette[n][1], palette[n][2]];
        }
        else
        {
            // old good RED...BLUE
            var cr = 255 * (v - min) / diff;
            var cb = 255 * ( 1 - (v - min) / diff);
            return [cr, 0, cb ];
        }

    }


    function palette( arr ) {
        if (!arr || arr.length == 0) {
            return [];
        }

        var colors = [];

        var mm = arrminmax(input);
        var min = mm.min;
        var max = mm.max;
        var diff = mm.diff;

        var palette = pal ? pal.slice(0) : []; // clone palette
        //debugger;

        for (var i=0; i<arr.length; i += 1)
        {
            var v = value2color( palette, arr[i], min, max );
            colors.push( v[0]/255.0 );
            colors.push( v[1]/255.0 );
            colors.push( v[2]/255.0 );
        }

        //minmax = mm;
        return colors;
    }

    function arrminmax (arr,initmin,initmax){
        var amin =  isnan(initmin) ? 10000000 : initmin;
        var amax =  isnan(initmax) ? -10000000 : initmax;

        if (isnan(useMin)) {
            for (var i=0; i<arr.length; i++)
            {
                if (amin > arr[i]) amin = arr[i];
            }
        }
        else
            amin = useMin;

        if (isnan(useMax)) {
            for (var i=0; i<arr.length; i++)
            {
                if (amax < arr[i]) amax = arr[i];
            }
        }
        else
            amax = useMax;

        var res = {'min': amin, 'max': amax, 'diff':(amax-amin)};
        console.log("computed minmax res=",res);
        return res;
    }


    ///////////////////// визуальная часть


    property var ctag: "right"

    property bool showPalette: true
    // показывать ли палитру
    property int mode: 2
    // 1 - вертикальная
    // 2 - горизонтальная

    Loader {
        property var tag: ctag

        source: {
            if (!showPalette) return false;
            if (mode == 2) return Qt.resolvedUrl("PaletteH.qml")
            return Qt.resolvedUrl("PaletteV.qml")
        }
    }

    /////////////////////// вспомогательные функции

    function componentToHex(c) {
        if (typeof(c) === "undefined") {
            debugger;
        }
        var hex = c.toString(16);
        return hex.length == 1 ? "0" + hex : hex;
    }

    function rgbToHex(r, g, b) {
        return "#" + componentToHex(r) + componentToHex(g) + componentToHex(b);
    }

    function tri2hex( triarr ) {
        return rgbToHex( Math.floor(triarr[0]*255),Math.floor(triarr[1]*255),Math.floor(triarr[2]*255) )
    }

    function tri2hex2( triarr ) {
        return rgbToHex( Math.floor(triarr[0]),Math.floor(triarr[1]),Math.floor(triarr[2]) )
    }

    function pal2hex( index ) {
        //debugger;
        return rgbToHex( pal[index][0] ,pal[index][1],pal[index][2] );
    }

}  
