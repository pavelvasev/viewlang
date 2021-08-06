// extract from Scene - only 3D things
import QtQuick 1.1

SceneObject {
  anchors.fill: parent
  
  property bool isScene: true

  id: sceneObj

  title: "Scene"

  property var scopeName: ""
  
  property var flat: false
  property var text: "Сцена"

  property var tag: "export"

  property alias centerPoint: cameraControl.centerPoint
  property alias center: cameraControl.centerPoint
  property alias cameraCenter: cameraControl.centerPoint  
  // property alias cameraLook: cameraControl.centerPoint

  property alias cameraPos: cameraControl.cameraPosition
  property alias cameraPosReal: cameraControl.realCameraPosition

  property alias cameraControlC:cameraControl
  CameraControl {
    id: cameraControl
  }

  /*
  ParamUrlHashing {
    property: "center"
    name: isRoot? "cameraCenter" : ""
  }

  ParamUrlHashing {
    property: "cameraPosReal"
    propertyWrite: "cameraPos"
    name: isRoot? "cameraPos" : ""
  }
  */  
 
   //property real sceneTime: sceneObj.findRootSpace() === sceneObj ? sceneObj.thetime : sceneObj.findRootSpace().sceneTime
   property real sceneTime: thetime
   property real thetime: 0
 
   ////////////////////// lights

   property alias sceneColor: alight.color
   property alias light0: alight
   property alias light1: plight1
   property alias light2: plight2
   property bool defaultLightsEnabled: true

   AmbientLight {
     id: alight
     color: 0x404040
     enabled: isRoot
   }
   
   PointLight {
     id: plight1
     color: 0xffffff
     enabled: isRoot && defaultLightsEnabled
     position: [50,50,50]
   }
   
   PointLight {
     id: plight2
     color: 0xffffff
     enabled: isRoot && defaultLightsEnabled
     position: [-50,-50,-50]
   }
   
   property bool isRoot: findRootScene( sceneObj ) === sceneObj

   property bool showLights: false
}
