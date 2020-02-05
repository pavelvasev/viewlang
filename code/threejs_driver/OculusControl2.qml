// this is modern version for threejs 112
Row {
   id: oc
   property var initialized: false

    CheckBoxParam {
        id: cbOculus
        width: 50
        text: "VR"

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

