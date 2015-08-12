import QtQuick 1.1

SceneSpace {
  anchors.fill: parent

  id: sceneObj

  title: "Scene"

  property var scopeName: ""
  
  property var flat: false
  property var text: "Сцена"

  property var help: ""
  ///property var helpTitle: ""

  property var helpText: {
      if (typeof(help) === "string") return help;
      //var res = helpTitle;
      var res = "";
      for (var i=0; i<help.length; i++) {
        var link = help[i];
        var a = "<a target='_blank' href=\"" + link[1] + "\">"+link[0]+"</a>";
        res = res + (i > 0 ? " | " : "") + a;
      }
      return res;
  }
  
  property var showDriverControls: false
  property alias driverControls: driverControlsA
  property alias axes: driverControls.axes

  DriverControls {
    id: driverControlsA
    visible: showDriverControls
    property var refineDisabled: !showDriverControls
  }

  property var tag: "export"

  property alias centerPoint: cameraControl.centerPoint
  property alias center: cameraControl.centerPoint
  property alias cameraCenter: cameraControl.centerPoint  

  property alias cameraPos: cameraControl.cameraPosition
  property alias cameraPosReal: cameraControl.realCameraPosition
  
  CameraControl {
    id: cameraControl
  }

  ParamUrlHashing {
    property: "center"
    name: isRoot? "cameraCenter" : ""
  }
  ParamUrlHashing {
    property: "cameraPosReal"
    propertyWrite: "cameraPos"
    name: isRoot? "cameraPos" : ""
  }  
 
  property var rootScene: sceneObj.findRootSpace()
  property var isRoot: rootScene === sceneObj
  
  Component.onCompleted: {
     if (sceneObj.findRootSpace() === sceneObj) { //if (!parent) {
       showDriverControls = true;
       refineSelf();
     }
  }
  
  /*
  property var lastConsoleMessage: ""
  Text {
    anchors.marginTop: 3
    text: "log:" + lastConsoleMessage.substring(0,50)
//    visible: showDriverControls
    property var tag: "bottom"
  }
  */

  /*
   function loadFile( file_or_path, handler ) {
      return loadFileBase( Qt.resolvedUrl(file_or_path), handler );
   }
   */

   property var loadingFilesHash: { return {}; }
   property var loadingFilesArr: {
     var acc = [];
     for (var i in loadingFilesHash)
       acc.push( i + " " + loadingFilesHash[i] );
     return acc;
   }

   Text {
     text: loadingFilesArr.join("\n")
     anchors.right: parent.right  -84
     anchors.bottom: parent.bottom-7
     
    Rectangle {
     anchors.fill: parent
     z: -1
     color: "#070"
    }
   }
   
   ///////////////// заказ пересбора 2д-гуи 

   function refineLater()
   {
     needRefine = true;
   }

   property var needRefine: false   

   RenderTick {
     onAction: {
       if (needRefine) {
         needRefine = false;
         sceneObj.refineAll();
       }
       sceneObj.thetime = time;
     }
   }
   
   //property real sceneTime: sceneObj.findRootSpace() === sceneObj ? sceneObj.thetime : sceneObj.findRootSpace().sceneTime
   property real sceneTime: thetime
   property real thetime: 0
 
   ////////////////////// lights
   
   property alias light0: alight
   property alias sceneColor: alight.color
   property alias light1: plight1
   property alias light2: plight2
   
   AmbientLight {
     id: alight
     color: 0x404040
     enabled: isRoot
   }
   
   PointLight {
     id: plight1
     color: 0xffffff
     enabled: isRoot
     position: [50,50,50]
   }
   
   PointLight {
     id: plight2
     color: 0xffffff
     enabled: isRoot
     position: [-50,-50,-50]
   }

   property bool showLights: false

   /////////////////////////////////
   property var gatheredParams: []
 
   /////////////////////////////////
   property var showControls: true

   toolbarWidgets.visible: showControls
   leftWidgets.visible: showControls
   rightWidgets.visible: showControls
   rightBottomWidgets.visible: showControls
   bottomWidgets.visible: showControls

   //////////////////////////////////

   property alias oscManager: oscManagerA
   ParamOscRoot {
     id: oscManagerA
     enabled: false
   }


  signal animationTick(); 

}
