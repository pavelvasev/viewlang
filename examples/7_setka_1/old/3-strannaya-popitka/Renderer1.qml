Item {
  // вход
  property var zones: []
  property var pointsRadius: 0.3

  property var colortable: [0xff, 0xff00, 0xff0000, 0xffff, 0xffff00]

  function getPointsItem( idx ) {
    return rep.children[idx] ? rep.children[idx].children[0] : null
  }  
  
  Repeater {
    id: rep
    model: zones.length
    
    Item {
      Points {
        positions: zones[ index ]
        color: colortable[ index % colortable.length ]
        radius: pointsRadius
        opacity: op.value / 100.0
        Component.onCompleted: makeLater(this);
        id: pt
      }
      Param {
        text: "Opacity zone "+index
        id: op
        property var tag: "left"
        value: 100
        color: pt.color
        Component.onCompleted: thescene.refineAll() 
      }
    }
  }

}  