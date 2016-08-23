Text {
  y: 3
  css.cursor: "pointer"
  signal clicked();

  MouseArea {
    anchors.fill: parent
    onClicked: parent.clicked();
    id: ma
  }

  property var tooltip: ""
  onTooltipChanged: ma.dom.title = tooltip;
  Component.onCompleted: ma.dom.title = tooltip;
}