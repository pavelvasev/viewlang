// this is modern version for threejs 112

/* to turn webvr on in current chrome (as of 02-2020),
   open chrome://flags/ and enable all VR and XR things AND DISABLE xr sandboxing feature.
   (see https://discourse.threejs.org/t/oculus-quest-and-xr-content-over-link/12306 for more information)
*/

Row {
   id: oc
   property var initialized: false

    CheckBoxParam {
        id: cbOculus
        width: 50
        text: "VR"
        paramAnimation.enabled: false

        onCheckedChanged: {
          if (!oc.initialized) {
            la_require( "VRButton_patched.js",function() {
              document.body.appendChild( VRButton.createButton( renderer ) );
              threejs.renderer.xr.enabled = true;
            } );
            oc.initialized = true;
          }
        }
    }

} // row