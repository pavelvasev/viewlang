Item {
  id: it
  // вход
  property var zones: []
  property var colortable: [0xff, 0xff00, 0xff0000, 0xffff, 0xffff00]


  
  Repeater {
    id: rep
    model: zones.length

    Linestrip {
        positions: zones[ index ]
        //opacity: op.value / 100.0
        Component.onCompleted: makeLater(this);        
        //color: pt.color
        visible: it.visible //lsParam.value>0
    }      
  }

}  