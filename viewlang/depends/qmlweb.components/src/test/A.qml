Rectangle {
  x: 20
  color: "green"
//  anchors.fill: parent  
  Text {
    text: "A. This rect have no width/heigth specified and will be stretched by loader"
  }
  Text {
    y: 30
    text: "result of call to foo() = " + (typeof(foo)==="undefined" ? "foo is undefined" : foo())
  }    
}