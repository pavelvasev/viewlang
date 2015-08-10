Item {
  // вход
  property var input // одномерный массив данных
  property var hivalue: 20 // какое значение "подсветить"
  
  //property alias file: palloader.file
  property var file: Qt.resolvedUrl("rainbow.rgb") // откуда брать палитру
  property var revert: false // повернуть цвета палитры задом-наперед
  
  // выход
  property var output: palette( input ) // цвета, в упаковке 1-мерный массив [r,g,b,r,g,b,...]

  property var minmax: arrminmax( input ); // вычисленное минимальное и макс. значения

  CsvLoader {
    file: parent.file
    skip: "#"
    id: palloader
    revert: parent.revert
    MultArray {
      id: multedPalette
      //mult: 1/255.0
      div: 255.0
    }
  }
  
  property var pal: multedPalette.output
//  property var pal: []

  function value2color( palette, v, min, max ) {
      var diff = max - min;
      //debugger;
      if (palette.length > 0) {
        var n = palette.length - 1 - Math.floor( (palette.length-1) * ((v - min)) / diff );

        if (n < 0) n = 0; 
        if (n >= palette.length) n = palette.length-1;
        
        return [palette[n][0], palette[n][1], palette[n][2]];
        /*
        colors.push( pallette[n][0] );
        colors.push( pallette[n][1] );
        colors.push( pallette[n][2] );
        */
      }
      else
      {
        // old good RED...BLUE
        var cr = 1 * (v - min) / diff;
        var cb = 1 * ( 1 - (v - min) / diff);
        return [cr, 0, cb ];
        /*
        colors.push( cr );
        colors.push( 0 );
        colors.push( cb );
        */
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
    
    for (var i=0; i<arr.length; i += 1)
    {
      var v = value2color( palette, arr[i], min, max );
      colors.push.apply(colors, v); 
    }

    //minmax = mm;
    return colors;
  }
  
  function arrminmax (arr){
      var amin =  10000000;
      var amax = -10000000;

      for (var i=0; i<arr.length; i++)
      {
        var val = arr[i];
        if (amin > val) amin = val;
        if (amax < val) amax = val;
      }
      return {'min': amin, 'max': amax, 'diff':(amax-amin)};
  }    
  

  property var tagPlace: "right"
 
  /*
  Text {
    property var tag: tagPlace
    width: 100
  }
  */


 /* 
  Rectangle {
    width: 60
    height: 5
    x: all.x
    y: all.y
    border.color:  "black"
  }
*/  
  
  Column {
    id: all
    Text {
      anchors.centerIn: parent
      text: minmax.max
    }
  
    property var tag: tagPlace

    width: 40
    Repeater {
      id:rep
      model: 256
      Rectangle {
        width: 40
        width: Math.abs( (minmax.max - hivalue) / minmax.diff - index / rep.count ) < 0.01 ? 50 : 40
        x: width > 40 ? -5: 0
        //border.color: x == 0 ? "transparent" : "black"        

        height: 1
        //color: tri2hex( palette( [ minmax.max - minmax.diff * index / rep.count ] ) )
        //color: { return pal && pal.length == 0 ? "green" : pal2hex( Math.floor( pal.length * index / 256 ) ); }
        //color: rgbToHex( pal[ index ][0]*255,0,0);
        color: tri2hex( value2color( pal, index, 0, 255 ) );

      } 
    }

    Text {
      text: minmax.min
      anchors.centerIn: parent
    }
    
  }
  


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
/*
function rgbToHex3(arr) {
    var res =  "#" + componentToHex(Math.floor( arr[0]*255) + componentToHex(arr[1]*255) + componentToHex(arr[2]*255);
    console.log(res,arr[0]*255,arr[1]*255,arr[2]*255);
    return res;
}  
*/

  function tri2hex( triarr ) {
     return rgbToHex( Math.floor(triarr[0]*255),Math.floor(triarr[1]*255),Math.floor(triarr[2]*255) )
  } 

  function pal2hex( index ) {
    //debugger;
    return rgbToHex( pal[index][0] ,pal[index][1],pal[index][2] );
  }
  
}  