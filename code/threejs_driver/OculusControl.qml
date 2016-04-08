Row {
/*
    Button {
      text: cbOculus.text
      onClicked: cbOculus.checked = !cbOculus.checked;
    }
*/

    CheckBox {
        id: cbOculus
        width: 140
        text: enabled ? "Окулус" : "Где Окулус?"
        property var enabled: false
        onCheckedChanged: {
            //window.focus(); // we need to release focus from this checkbox, because DK2 will ask to hit any key
            cbOculus2.dom.focus();
            if (checked && this.vrrenderer) {
              selectedRenderer = this.vrrenderer;
              this.vrrenderer.setFullScreen( true );
            }
            else {
              selectedRenderer = renderer;
              threeJsWindowResize();
            }
        }
    }
    CheckBox {
        id: cbOculus2
        width: 1
    }
    
    Component.onCompleted: {
        if (!sceneObj.isRoot) return;
        
        if (!WEBVR.isLatestAvailable()) {
            console.log("WEBVR.isLatestAvailable() => false, message:",WEBVR.getMessage());
            return;
        }

        console.log("WEBVR.isLatestAvailable() => true");
        if (!WEBVR.isAvailable()) {
            console.log("WEBVR.isAvailable() => false");
            return;
        }

        la_require( "three.js/examples/js/effects/VREffect.js",function() {
          la_require( "three.js/examples/js/controls/VRControls.js",function() {

    	    //cbOculus.controls = new THREE.VRControls( camera );

    		cbOculus.vrrenderer = new THREE.VREffect( renderer );
            
            var btn = WEBVR.getButton( cbOculus.vrrenderer );
            document.body.appendChild( btn );
            //
            //btn.onclick = function() {
            //  cbOculus.checked = true;
            //}
            
            cbOculus.enabled = true;
          });
        });
    }

} // row

