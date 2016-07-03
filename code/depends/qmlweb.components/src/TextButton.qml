Text {
  y: 3
  css.cursor: "pointer"
  signal clicked();

  MouseArea {
    anchors.fill: parent
    onClicked: parent.clicked();
  }  
}