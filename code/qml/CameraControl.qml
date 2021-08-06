// Работает только для ThreeJs...

Item {
  id: camcontrol
  
  property var centerPoint: [0,0,0]
  property var cameraPosition: [0,0,50]     // задается извне
  property var realCameraPosition: [0,0,50] // считывается нами из ThreeJs
  
  property var sceneControl: undefined
  // объект типа orbitControl и т.д., создается динамически
  
  function reset()
  {
    centerPoint = [0,0,0]
    cameraPosition = [0,0,50]
  }
  
  function updateCenter() {
    //console.log(333);
    if (sceneControl) {
      //sceneCenterPoint = new THREE.Vector3( centerPoint[0],centerPoint[1],centerPoint[2] );
      if (sceneControl.target.x != centerPoint[0] || sceneControl.target.y != centerPoint[1] || sceneControl.target.z != centerPoint[2]) {
        sceneControl.target = new THREE.Vector3( centerPoint[0],centerPoint[1],centerPoint[2] )
        sceneControl.update();
        // console.log("Новый центр (программа): ",centerPoint);
      }
    }
  }

  function writeCamPosToThreeJs() {
    //threejs.camera.position = new THREE.Vector3( cameraPosition[0], cameraPosition[1], cameraPosition[2] );
    if (threejs.camera.position.x == cameraPosition[0] &&
        threejs.camera.position.y == cameraPosition[1] &&
        threejs.camera.position.z == cameraPosition[2]) return;
        
    //console.log("new cam pos (prg)",cameraPosition,threejs.camera.position);
    threejs.camera.position.x = cameraPosition[0];
    threejs.camera.position.y = cameraPosition[1];
    threejs.camera.position.z = cameraPosition[2];
    //threejs.camera.updateProjectionMatrix();
    if (sceneControl) {
      //debugger;
      sceneControl.update();
    }
    readCamPosFromThreeJs();
  }
  
  function readCamPosFromThreeJs() {
      var q = [threejs.camera.position.x, threejs.camera.position.y, threejs.camera.position.z ];
      if (q[0] != realCameraPosition[0] || q[1] != realCameraPosition[1] || q[2] != realCameraPosition[2] ) {
        realCameraPosition = q;
      }
      return q;  
  }
  onCenterPointChanged: updateCenter();

  onCameraPositionChanged: {
    writeCamPosToThreeJs();
    camera_change_ctp(); // FEATURE-CAMERA-CHANGE-NOTIFY  
    //console.log("campos-changed")
  }

  property var imRoot: findRootScene( camcontrol ) === parent

  property var echoTimeout: null

  onImRootChanged: {
    if (!imRoot) return;
    setupControl( "OrbitControls" )
  }

  function setupControl( controlFile, controlType ) {
    if (!controlType) controlType = controlFile;

    var path = controlFile;
    if (path.indexOf("/") < 0) 
        path = "../threejs_driver/three.js-part/examples/js/controls/"+controlFile+".js";
    // "../threejs_driver/"+controlType+".js"

    la_require(path, function() {
    if (!imRoot) return;
    var cls = eval("THREE."+controlType);

    // remove old control
    if (sceneControl) sceneControl.dispose();

    sceneControl = new cls( threejs.camera, renderer.domElement );
    
    // sceneControl.enableRotate=false;
    threejs.sceneControl = sceneControl;

    updateCenter();
 
    var camera_change_event = { type: 'camera_change' } // FEATURE-CAMERA-CHANGE-NOTIFY  
   
    sceneControl.addEventListener( 'change', function() {
      threejs.scene.dispatchEvent(camera_change_event); // FEATURE-CAMERA-CHANGE-NOTIFY  

      if (echoTimeout) clearTimeout( echoTimeout );
      
      echoTimeout = setTimeout( function () {

        var q = readCamPosFromThreeJs();

        var n = [ sceneControl.target.x,sceneControl.target.y,sceneControl.target.z ];
        
        if (n[0] != centerPoint[0] || n[1] != centerPoint[1] || n[2] != centerPoint[2] ) {
          console.log( "Новый центр (пользователь)");
          console.log( "center:",n );
          console.log( "cameraPos:",q );
          centerPoint = n;
        }

      } // timeout
      , 500 );

    } );
  } );
  }

  Component.onCompleted: {
     readCamPosFromThreeJs();
  }

  // FEATURE-CAMERA-CHANGE-NOTIFY
  // we need get know when camera changes (for frustum culling so on)
  // various ways there https://stackoverflow.com/questions/33983889/fire-code-everytime-camera-position-changes-in-three-js
  // current feauture uses event in threejs.scene
  function camera_change_ctp() {
      var camera_change_event = { type: 'camera_change' } 
      threejs.scene.dispatchEvent(camera_change_event); 
  }
  
}