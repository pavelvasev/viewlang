Row {
/*
    CheckBox {
        id: cbOculus
        width: 140
        text: enabled ? "Окулус" : "Где Окулус?"
        property var enabled: false

        onCheckedChanged: {
            if (checked && this.vrrenderer) {
              selectedRenderer = this.vrrenderer;
              this.vrrenderer.setFullScreen( true );
            }
            else {
              this.vrrenderer.setFullScreen( false );
              selectedRenderer = renderer;
              threeJsWindowResize();
            }
        }
    }
*/    
    
    Component.onCompleted: {
        if (!sceneObj.isRoot) return;

		renderer.vr.enabled = true;
                
		WEBVR.getVRDisplay( function ( display ) {
			renderer.vr.setDevice( display );

            // theejs developers are such developers..
            // lets config camera
            /* // not so easy ... todo
            var obj = new THREE.Object3D();
            obj.scale = 0.1;
            obj.position = new THREE.Vector3( 0, 100, 0 );
            //obj.updateMatrix();
            obj.updateMatrixWorld();
            threejs.camera.parent = obj;
            */
            
            renderer.vr.standing = true;
            
            var btn = WEBVR.getButton( display, renderer.domElement );
            document.body.appendChild( btn );
        } );

        
        /*
        if (!WEBVR.isLatestAvailable()) {
            console.log("WEBVR.isLatestAvailable() => false"); //, message:");//,WEBVR.getMessage());
            return;
        }
        
        console.log("WEBVR.isLatestAvailable() => true");
        if (!WEBVR.isAvailable()) {
            console.log("WEBVR.isAvailable() => false");
            return;
        }

        la_require( "three.js/examples/js/effects/VREffect.js",function() {
          la_require( "three.js/examples/js/controls/VRControls.js",function() {
          
    	    vrControl = new THREE.VRControls( camera );
            vrControl.scale = 10;
            
    		cbOculus.vrrenderer = new THREE.VREffect( renderer );
            
            var btn = WEBVR.getButton( cbOculus.vrrenderer );
            document.body.appendChild( btn );
            
            btn.onclick = function() {
              cbOculus.checked = !cbOculus.checked;
              btn.textContent = cbOculus.checked ? " EXIT VR" : "ENTER VR";
            }
            
            var btn2 = WEBVR.getButtonPose();
            document.body.appendChild( btn2 );
            btn2.onclick = function() {
              vrControl.resetSensor();
            }            
            
            cbOculus.enabled = true;
          });
        });
        */
    }

} // row

