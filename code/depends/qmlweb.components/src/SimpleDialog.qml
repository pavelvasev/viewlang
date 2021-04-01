Rectangle {
  id: dlg
  z: 5000
  width: 400
  height: 200

  property var sWidth: qmlEngine.rootObject.width
  property var sHeight: qmlEngine.rootObject.height
  //property var isMobile: e.rootObject.isMobile

  property bool syncingSize: false
  function syncSize() {
    //console.log("sync size, ismob is",isMobile,sWidth,sHeight,width,height );
    if (syncingSize) return;
    syncingSize=true;
    if (sWidth > 100)
      if (width > sWidth || isMobile) width = sWidth;
    if (sHeight > 100)
      if (height > sHeight || isMobile) height = sHeight;
    //console.log("after sync size, ismob is",isMobile,sWidth,sHeight,width,height );    
    syncingSize=false;
  }
  onWidthChanged: syncSize();
  onHeightChanged: syncSize();
  onSWidthChanged: syncSize();
  onSHeightChanged: syncSize();
  
  Component.onCompleted: {
    dlg.oldSpaceParent = dlg.parent; // надо сохранить - чтобы scope нормально считались
    parent = engine.rootObject;
  }

  property var title: ""

  visible: false
  color: "aaaaaa"
  //opacity: 0.9
  border.width:1	
  border.color:"grey"
  
  property var refineDisabled: true // необходимо чтобы вещи с tag не вытаскивали из диалога

  default property alias newChildren: content.data

  anchors.horizontalCenter: parent.horizontalCenter
  anchors.verticalCenter: parent.verticalCenter
  
  signal afterOpen();
  signal afterClose();
  
//  function open() { visible=true; afterOpen(); }
//  function close() { visible=false; afterClose(); }
   
  function open() { visible=true; afterOpen(); }
  function close() { visible=false; afterClose(); }

  Text {
    x:5
    y:5

    text: dlg.title
    id: titletext
    font.bold: true
    font.pointSize: 12
    wrapMode: Text.WordWrap
    anchors.right: parent.right-25
    anchors.left: parent.left+5

      
  }
  property alias titleText: titletext
  
  property var lang: (navigator.language || navigator.userLanguage)
  property var ru: lang && lang.indexOf && lang.indexOf("ru") >= 0
  
  property alias closeItem: tclose
  Text {
    id: tclose
    anchors.right: parent.right
    anchors.margins:5
    y: 2
    //text: ru ? "Закрыть" : "Close"
    text: "     [X]"
    css.cursor: "pointer"
    z: 5
    font.pointSize: 15
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
    anchors.topMargin: dlg.title ? titletext.height + titletext.y + 5 : 5
    id: content
    anchors.fill: parent
    //color: "transparent"
    //color: "red"
    
    MouseArea {
      anchors.fill: parent
      property var pt
      onClicked: {
        if (pt) {
          var dt = performance.now() - pt;
          console.log(dt);
          if (dt < 500) dlg.close()
        }
        pt = performance.now();
        
      }
    }
  }
  property alias contentArea: content
  
  onChildrenChanged: {
    // правим багу qmlweb-а
    setTimeout( function() {
    if (children.length > 3) {
      var cc = children.slice();
      for (var i=3; i<cc.length; i++)
        cc[i].parent = content;
    }
    }, 0 );
  }
}