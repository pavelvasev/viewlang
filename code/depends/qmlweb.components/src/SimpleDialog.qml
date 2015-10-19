Rectangle {
  id: dlg
  z: 5000
  width: 400
  height: 200
  
  Component.onCompleted: {
   parent = engine.rootObject;
  }

  property var title: ""

  visible: false
  color: "aaaaaa"
  //opacity: 0.9
  border.width:1	
  border.color:"grey"

  default property alias newChildren: content.data

  anchors.horizontalCenter: parent.horizontalCenter
  anchors.verticalCenter: parent.verticalCenter
  
  signal afterOpen();
  signal afterClose();
  
//  function open() { visible=true; afterOpen(); }
//  function close() { visible=false; afterClose(); }
   
  function open() { console.log("open called!"); visible=true; afterOpen(); }
  function close() { console.log("close called!. making visible=false"); visible=false; console.log("calling afterClose"); afterClose(); console.log("close finished"); }

  Text {
    x:5
    y:2
    text: dlg.title
    id: titletext
    font.bold: true
  }  
  
  property var lang: (navigator.language || navigator.userLanguage)
  property var ru: lang && lang.indexOf && lang.indexOf("ru") >= 0
  
  Text {
    anchors.right: parent.right
    anchors.margins:5
    y: 2
    text: ru ? "Закрыть" : "Close"
    css.cursor: "pointer"
    z: 5
    //css.pointerEvents: "auto"
    
    MouseArea {
      anchors.fill: parent
      onClicked: {
        dlg.close()
      }
    }
  }

  Rectangle {
    anchors.margins: 5
    anchors.topMargin: dlg.title ? titletext.height + titletext.y + 2 : 5
    id: content
    anchors.fill: parent
    color: "transparent"

  }
}