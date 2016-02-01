Row {
/*
    Button {
      text: cbOculus.text
      onClicked: cbOculus.checked = !cbOculus.checked;
    }
*/

    CheckBox {
//        visible: false
        id: cbOculus
        width: 140
        text: enabled ? "Окулус" : "Где Окулус?"
        property var enabled: false
        onCheckedChanged: {
            //window.focus(); // we need to release focus from this checkbox, because DK2 will ask to hit any key
            cbOculus2.dom.focus();
            if (checked && this.vrrenderer) {
              selectedRenderer = this.vrrenderer;
              goFullScreen();
              vrHMDSensor = vrHMDSensorFound;
            }
            else {
              selectedRenderer = renderer;
              vrHMDSensor = null;
              threeJsWindowResize();
            }
        }
    }
    CheckBox {
        id: cbOculus2
    }

    // vrHMD объявлено в driver.js

    function goFullScreen() {

        var container = document.body;
        //var container = renderer.domElement;

        if (container.mozRequestFullScreen) {
            container.mozRequestFullScreen({vrDisplay: vrHMD});
        } else if (container.webkitRequestFullscreen) {
            container.webkitRequestFullscreen({vrDisplay: vrHMD});
        }
    }
    
    Component.onCompleted: {
        if (!sceneObj.isRoot) return;

        if (navigator.getVRDevices) {
            console.log("WebVR апи [chrome] обнаружено, подан запрос на поиск шлема и сенсора");
            navigator.getVRDevices().then(vrDeviceCallback);
        } else if (navigator.mozGetVRDevices) {
            console.log("WebVR апи [firefox] обнаружено, подан запрос на поиск шлема и сенсора");
            navigator.mozGetVRDevices(vrDeviceCallback);
        }
        else {
            console.log("WebVR апи не обнаружено");
        }

    }


    function vrDeviceCallback(vrdevs) {
        for (var i = 0; i < vrdevs.length; ++i) {
            if (vrdevs[i] instanceof HMDVRDevice) {
                vrHMD = vrdevs[i];
                break;
            }
        }
        for (var i = 0; i < vrdevs.length; ++i) {
            if (vrdevs[i] instanceof PositionSensorVRDevice &&
                vrdevs[i].hardwareUnitId == vrHMD.hardwareUnitId) {
                vrHMDSensorFound = vrdevs[i];
                break;
            }
        }
        
        console.log("Обнаружен шлем vrHMD=",vrHMD);
        console.log("Обнаружен сенсор vrHMDSensor=",vrHMDSensorFound);

        if (vrHMD) {
            la_require( "VRRenderer.js",function() {
                cbOculus.vrrenderer = new THREE.VRRenderer(renderer, vrHMD );
                cbOculus.enabled = true;
            } );

            /*
            window.addEventListener("keypress", function(e) {
                            if (e.charCode == 'f'.charCodeAt(0)) {
                            cbOculus.checked = true;
                            }
            }, false);
            */
        } // if vrHMD
    }

} // row

