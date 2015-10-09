Item {
  property var input // одномерный массив
  property var output: palette( input ) // цвета

  property var minmax: arrminmax( input );

  function palette( arr ) {
    var colors = [];
    
    //var minmax = arrminmax(arr);
    
    for (var i=0; i<arr.length; i += 1)
    {
      var v = arr[i];
      var cr = 1 * (v - minmax.min) / minmax.diff;
      var cb = 1 * ( 1 - (v - minmax.min) / minmax.diff);
      colors.push( cr );
      colors.push( 0 );
      colors.push( cb );
    }
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
  
  Column {
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
        height: 1
        color: tri2hex( palette( [ minmax.max - minmax.diff * index / rep.count ] ) )
      } 
    }

    Text {
      text: minmax.min
      anchors.centerIn: parent
    }
    
  }



function componentToHex(c) {
    var hex = c.toString(16);
    return hex.length == 1 ? "0" + hex : hex;
}

function rgbToHex(r, g, b) {
    return "#" + componentToHex(r) + componentToHex(g) + componentToHex(b);
}  

  function tri2hex( triarr ) {
     return rgbToHex( Math.floor(triarr[0]*255),Math.floor(triarr[1]*255),Math.floor(triarr[2]*255) )
  } 
  
  
}  