  Column {

    id: all
    Text {

      anchors.horizontalCenter : parent.horizontalCenter 
      text: !isnan(minmax.max) && minmax.max.toFixed ? Number(minmax.max.toFixed(4)) : minmax.max
    }
  
    //property var tag: ctag
    
    width: 40
    
    Repeater {
      id:rep
      model: 256
      Rectangle {
        //width: 40
        width: Math.abs( (minmax.max - hivalue) / minmax.diff - index / rep.model ) < 0.01 ? 50 : 40
        x: width > 40 ? -5: 0
        //border.color: x == 0 ? "transparent" : "black"        
        
        height: 1
        //color: tri2hex( palette( [ minmax.max - minmax.diff * index / rep.count ] ) )
        //color: { return pal && pal.length == 0 ? "green" : pal2hex( Math.floor( pal.length * index / 256 ) ); }
        //color: rgbToHex( pal[ index ][0]*255,0,0);
        color: tri2hex2( value2color( pal, 255 - index, 0, 255 ) );
        
      } 
    }

    Text {
      text: !isnan(minmax.min) && minmax.min.toFixed ? Number(minmax.min.toFixed(4)) : minmax.min
      anchors.horizontalCenter : parent.horizontalCenter 
    }
    
  }
