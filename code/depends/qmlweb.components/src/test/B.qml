Rectangle {
  color: "cyan"
  //anchors.fill: parent
  width: 50
  height: 50

  Text {
    text: "B. This rect has size=50x50. But may be streched by loader."
  }

  Text {
    y: 30
    text: "the value of var r15="+(typeof(r15) === "undefined" ? "undefined" : r15)
  }  
}