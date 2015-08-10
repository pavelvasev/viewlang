Loader {
  property var title: "Tab"
  anchors.fill: parent
  
  active: false
  
  onVisibleChanged: if (visible) active = true;
}