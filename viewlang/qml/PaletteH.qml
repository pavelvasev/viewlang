Column {
    //property var tag: ctag
    width: 192
    
    property var target_width: width

  Item {
    width: all.width
    height: all.height
  Row {
    id: all
    anchors.margins: -5
    
    Repeater {
      id:rep
      model: 64
      Rectangle {
        //width: 40
        height: 25
        y: 0
        //height: Math.abs( (minmax.max - hivalue) / minmax.diff - index / rep.model ) < 0.01 ? 35 : 25
        //y: height > 25 ? -5: 0
        //border.color: x == 0 ? "transparent" : "black"        
        
        width: target_width / rep.model
        //color: tri2hex( palette( [ minmax.max - minmax.diff * index / rep.count ] ) )
        //color: { return pal && pal.length == 0 ? "green" : pal2hex( Math.floor( pal.length * index / 256 ) ); }
        //color: rgbToHex( pal[ index ][0]*255,0,0);
        color: tri2hex2( value2color( pal, index*width*256.0/target_width, 0, 255 ) );

      } 
    }
    
  } // row
    
    Rectangle {
      width: 2
      height: all.height+3
      y: -2
      x:  ( (hivalue - minmax.min) / minmax.diff ) * target_width -1
      visible: !isnan(hivalue)
      border.color: "black" 
      color: "transparent"
      z: 1
    }
  } // item

  
    Item {

    width: all.width
    height: 20
    //height: all.height
    
    Text {
      anchors.verticalCenter : parent.verticalCenter 
//      text: !isnan(minmax.max) && minmax.max.toFixed ? Number(minmax.max.toFixed(6)) : minmax.max
      text: minmax.max
      anchors.right: parent.right
      z:1
    }

    Text {
      text: !isnan(minmax.min) && minmax.min.toFixed ? Number(minmax.min.toFixed(4)) : minmax.min
//      text: minmax.min
      anchors.verticalCenter : parent.verticalCenter 
      
      z:1
    }
    
    /*
    Rectangle {
      width: 5
      height: 5
      y: 4
      x: ( (hivalue - minmax.min) / minmax.diff ) * target_width
      visible: !isnan(hivalue)
      border.color: "black" 
      z: 1
    }    
    */
    }    
  

  } // column
