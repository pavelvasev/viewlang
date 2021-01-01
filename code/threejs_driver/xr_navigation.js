import { XRControllerModelFactory } from "./three.js-part/examples/jsm/webxr/XRControllerModelFactory.js";

// thanx
// https://stackoverflow.com/a/63271335


/*
// https://console.re/pvxrd
var consolere = {
  channel:'pvxrd',
  api:'//console.re/connector.js',
  ready: function(c) {var d=document,s=d.createElement('script'),l;s.src=this.api;s.id='consolerescript';s.setAttribute('data-channel', this.channel);s.onreadystatechange=s.onload=function(){if(!l){c();}l=true;};d.getElementsByTagName('head')[0].appendChild(s);}
};
consolere.ready(function() {
  console.re.log('remote log test');
});
*/

var orig_qqq = renderer.xr.setSession;

renderer.xr.setSession = function(value) {
  orig_qqq(value);
  if (value)
    setup_my_vr_walk();
}

function setup_my_vr_walk() {

var controller1, controller2;
var controllerGrip1, controllerGrip2;

var raycaster,
    intersected = [];
var tempMatrix = new THREE.Matrix4();

var group, controls;

var dolly;
var cameraVector = new THREE.Vector3(); // create once and reuse it!
const prevGamePads = new Map();
var speedFactor = [0.1, 0.1, 0.1, 0.1];

var render_aspect_orig = render_aspect;
function render_patch() {
/*
    cleanIntersected();

    intersectObjects(controller1);
    intersectObjects(controller2);
*/    

    ////////////////////////////////////////
    //// MODIFICATIONS FROM THREEJS EXAMPLE

    //add gamepad polling for webxr to renderloop
    dollyMove();
    
    render_aspect_orig.apply();
}
render_aspect = render_patch;


function init() {
    group = new THREE.Group();
    scene.add(group);
    
// controllers
    controller1 = renderer.xr.getController(0);
    controller1.name="left";    ////MODIFIED, added .name="left"
    controller1.addEventListener("selectstart", onSelectStart);
    controller1.addEventListener("selectend", onSelectEnd);
    scene.add(controller1);

    controller2 = renderer.xr.getController(1);
    controller2.name="right";  ////MODIFIED added .name="right"
    controller2.addEventListener("selectstart", onSelectStart);
    controller2.addEventListener("selectend", onSelectEnd);
    scene.add(controller2);

    var controllerModelFactory = new XRControllerModelFactory();

    controllerGrip1 = renderer.xr.getControllerGrip(0);
    controllerGrip1.add(
        controllerModelFactory.createControllerModel(controllerGrip1)
    );
    scene.add(controllerGrip1);

    controllerGrip2 = renderer.xr.getControllerGrip(1);
    controllerGrip2.add(
        controllerModelFactory.createControllerModel(controllerGrip2)
    );
    scene.add(controllerGrip2);
    
    //Raycaster Geometry
    var geometry = new THREE.BufferGeometry().setFromPoints([
        new THREE.Vector3(0, 0, 0),
        new THREE.Vector3(0, 0, -1)
    ]);

    var line = new THREE.Line(geometry);
    line.name = "line";
    line.scale.z = 50;   //MODIFIED FOR LARGER SCENE

    controller1.add(line.clone());
    controller2.add(line.clone());

    raycaster = new THREE.Raycaster();
  
    ////////////////////////////////////////
    //// MODIFICATIONS FROM THREEJS EXAMPLE
    //// create group named 'dolly' and add camera and controllers to it
    //// will move dolly to move camera and controllers in webXR

    dolly = new THREE.Group();
    dolly.position.set(0, 0, 0);
    dolly.name = "dolly";
    scene.add(dolly);
    dolly.add(camera);
    dolly.add(controller1);
    dolly.add(controller2);
    dolly.add(controllerGrip1);
    dolly.add(controllerGrip2);
    
    //
    controls = qmlEngine.rootObject.cameraControlC.sceneControl;

}

function onSelectStart(event) {
    console.log("onSelectStart... ok");
    var controller = event.target;
    //console.re.log("select start, controller is",controller );
    return;

    var intersections = getIntersections(controller);

    if (intersections.length > 0) {
        var intersection = intersections[0];
        var object = intersection.object;
        object.material.emissive.b = 1;
        controller.attach(object);
        controller.userData.selected = object;
    }
}

function onSelectEnd(event) {
    console.log("onSelectEnd... ok");
    return;
    var controller = event.target;
    if (controller.userData.selected !== undefined) {
        var object = controller.userData.selected;
        object.material.emissive.b = 0;
        group.attach(object);
        controller.userData.selected = undefined;
    }
}

function getIntersections(controller) {
return;
    tempMatrix.identity().extractRotation(controller.matrixWorld);
    raycaster.ray.origin.setFromMatrixPosition(controller.matrixWorld);
    raycaster.ray.direction.set(0, 0, -1).applyMatrix4(tempMatrix);
    return raycaster.intersectObjects(group.children);
}

function intersectObjects(controller) {
  return;
    // Do not highlight when already selected

    if (controller.userData.selected !== undefined) return;

    var line = controller.getObjectByName("line");
    var intersections = getIntersections(controller);

    if (intersections.length > 0) {
        var intersection = intersections[0];

        ////////////////////////////////////////
        //// MODIFICATIONS FROM THREEJS EXAMPLE
        //// check if in webXR session
        //// if so, provide haptic feedback to the controller that raycasted onto object
        //// (only if haptic actuator is available)
        const session = renderer.xr.getSession();
        if (session) {  //only if we are in a webXR session
            for (const sourceXR of session.inputSources) {

                if (!sourceXR.gamepad) continue;
                if (
                    sourceXR &&
                    sourceXR.gamepad &&
                    sourceXR.gamepad.hapticActuators &&
                    sourceXR.gamepad.hapticActuators[0] &&
                    sourceXR.handedness == controller.name              
                ) {
                    var didPulse = sourceXR.gamepad.hapticActuators[0].pulse(0.8, 100);
                }
            }
        }
        ////
        ////////////////////////////////

        var object = intersection.object;
        object.material.emissive.r = 1;
        intersected.push(object);

        line.scale.z = intersection.distance;
    } else {
        line.scale.z = 50;   //MODIFIED AS OUR SCENE IS LARGER
    }
}

function cleanIntersected() {
    while (intersected.length) {
        var object = intersected.pop();
        object.material.emissive.r = 0;
    }
}


function dollyMove() {
  try {
    dollyMove2();
  } catch(err) {
    console.error("err in dollyMove2",err.message,err.stack );
    //console.re.error("err in dollyMove2",err.message,err.stack );
  }
}


function dollyMove2() {

    var handedness = "unknown";

    //determine if we are in an xr session
    const session = renderer.xr.getSession();
    let i = 0;

    if (session) {
        let xrCamera = renderer.xr.getCamera(camera);
        xrCamera.getWorldDirection(cameraVector);

        //a check to prevent console errors if only one input source
        if (isIterable(session.inputSources)) {
            for (const source of session.inputSources) {
                if (source && source.handedness) {
                    handedness = source.handedness; //left or right controllers
                }
                if (!source.gamepad) continue;
                const controller = renderer.xr.getController(i++);
                const old = prevGamePads.get(source);
                const data = {
                    handedness: handedness,
                    buttons: source.gamepad.buttons.map((b) => b.value),
                    axes: source.gamepad.axes.slice(0)
                };
                if (old) {
                    data.buttons.forEach((value, i) => {
                        //handlers for buttons
                        if (value !== old.buttons[i] || Math.abs(value) > 0.8) {
                            //check if it is 'all the way pushed'
                            if (value === 1) {
                                //console.log("Button" + i + "Down");
                                if (data.handedness == "left") {
                                    //console.log("Left Paddle Down");
                                    if (i == 1) {
                                        dolly.rotateY(-THREE.Math.degToRad(1));
                                    }
                                    if (i == 3) {
                                        //reset teleport to home position
                                        dolly.position.x = 0;
                                        dolly.position.y = 5;
                                        dolly.position.z = 0;
                                    }
                                } else {
                                    //console.log("Right Paddle Down");
                                    if (i == 1) {
                                        dolly.rotateY(THREE.Math.degToRad(1));
                                    }
                                }
                            } else {
                                // console.log("Button" + i + "Up");

                                if (i == 1) {
                                    //use the paddle buttons to rotate
                                    if (data.handedness == "left") {
                                        //console.log("Left Paddle Down");
                                        dolly.rotateY(-THREE.Math.degToRad(Math.abs(value)));
                                    } else {
                                        //console.log("Right Paddle Down");
                                        dolly.rotateY(THREE.Math.degToRad(Math.abs(value)));
                                    }
                                }
                            }
                        }
                    });
                    data.axes.forEach((value, i) => {
                        //handlers for thumbsticks
                        //if thumbstick axis has moved beyond the minimum threshold from center, windows mixed reality seems to wander up to about .17 with no input
                        if (Math.abs(value) > 0.2) {
                            //set the speedFactor per axis, with acceleration when holding above threshold, up to a max speed
                            speedFactor[i] > 1 ? (speedFactor[i] = 1) : (speedFactor[i] *= 1.001);
                            console.log(value, speedFactor[i], i);
                            if (i == 2) {
                                //left and right axis on thumbsticks
                                if (data.handedness == "left") {
                                    // (data.axes[2] > 0) ? console.log('left on left thumbstick') : console.log('right on left thumbstick')

                                    //move our dolly
                                    //we reverse the vectors 90degrees so we can do straffing side to side movement
                                    dolly.position.x -= cameraVector.z * speedFactor[i] * data.axes[2];
                                    dolly.position.z += cameraVector.x * speedFactor[i] * data.axes[2];

                                    //provide haptic feedback if available in browser
                                    if (false &&
                                        source.gamepad.hapticActuators &&
                                        source.gamepad.hapticActuators[0]
                                    ) {
                                        var pulseStrength = Math.abs(data.axes[2]) + Math.abs(data.axes[3]);
                                        if (pulseStrength > 0.75) {
                                            pulseStrength = 0.75;
                                        }

                                        var didPulse = source.gamepad.hapticActuators[0].pulse(
                                            pulseStrength,
                                            100
                                        );
                                    }
                                } else {
                                    // (data.axes[2] > 0) ? console.log('left on right thumbstick') : console.log('right on right thumbstick')
                                    dolly.rotateY(-THREE.Math.degToRad(data.axes[2]));
                                }
                                if (controls) controls.update();
                            }

                            if (i == 3) {
                                //up and down axis on thumbsticks
                                if (data.handedness == "left") {
                                    // (data.axes[3] > 0) ? console.log('up on left thumbstick') : console.log('down on left thumbstick')
                                    dolly.position.y -= speedFactor[i] * data.axes[3];
                                    //provide haptic feedback if available in browser
                                    if ( false &&
                                        source.gamepad.hapticActuators &&
                                        source.gamepad.hapticActuators[0]
                                    ) {
                                        var pulseStrength = Math.abs(data.axes[3]);
                                        if (pulseStrength > 0.75) {
                                            pulseStrength = 0.75;
                                        }
                                        var didPulse = source.gamepad.hapticActuators[0].pulse(
                                            pulseStrength,
                                            100
                                        );
                                    }
                                } else {
                                    // (data.axes[3] > 0) ? console.log('up on right thumbstick') : console.log('down on right thumbstick')
                                    dolly.position.x -= cameraVector.x * speedFactor[i] * data.axes[3];
                                    dolly.position.z -= cameraVector.z * speedFactor[i] * data.axes[3];

                                    //provide haptic feedback if available in browser
                                    if ( false &&
                                        source.gamepad.hapticActuators &&
                                        source.gamepad.hapticActuators[0]
                                    ) {
                                        var pulseStrength = Math.abs(data.axes[2]) + Math.abs(data.axes[3]);
                                        if (pulseStrength > 0.75) {
                                            pulseStrength = 0.75;
                                        }
                                        
                                        var didPulse = source.gamepad.hapticActuators[0].pulse(
                                            pulseStrength,
                                            100
                                        );
                                    }
                                }
                                if (controls) controls.update();
                            }
                        } else {
                            //axis below threshold - reset the speedFactor if it is greater than zero  or 0.025 but below our threshold
                            if (Math.abs(value) > 0.025) {
                                speedFactor[i] = 0.025;
                            }
                        }
                    });
                }
                ///store this frames data to compate with in the next frame
                prevGamePads.set(source, data);
            }
        }
    }
} // dolly

function isIterable(obj) {  //function to check if object is iterable
    // checks for null and undefined
    if (obj == null) {
        return false;
    }
    return typeof obj[Symbol.iterator] === "function";
}

  init();

}