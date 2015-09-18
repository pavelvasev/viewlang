  Rectangle { 
    property var firstPlot: parent
    property var s: parent

    width: 100
    height: 100 * firstPlot.height / firstPlot.width 
    anchors.left: firstPlot.left + 50
    anchors.bottom: firstPlot.bottom -50 - 20
    color: "blue"
    opacity: 0.5
    //property var tag: firstPlot.tag
    z:200

    MouseArea {
      anchors.fill: parent
      onClicked: {
        s.reset();
        //console.log("reset");
      }
    }    

    Rectangle {
      x: firstPlot.selection[0]*parent.width 
      y: (1-firstPlot.selection[3])*parent.height
      width: (firstPlot.selection[1]-firstPlot.selection[0])*parent.width
      height: (firstPlot.selection[3]-firstPlot.selection[2])*parent.height
      color: "red"
      //border.color: "cyan"
      //border.width: 1
      visible: (firstPlot.selection[1]-firstPlot.selection[0]) < 1 && (firstPlot.selection[3]-firstPlot.selection[2]) < 1
    }

  }
