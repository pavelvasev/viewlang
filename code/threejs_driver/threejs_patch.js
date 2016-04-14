////////////////////////////////////

THREE.BufferGeometry.prototype.computeLineDistances = function () {
  	var positions = this.attributes.position.array;

  	var vector = new THREE.Vector3(), vector_prev = new THREE.Vector3();;
		var d = 0;

		if (!positions) return;
    // todo optimize - do not recreate if exist of same length
		this.addAttribute( 'lineDistance', new THREE.BufferAttribute( new Float32Array( positions.length ), 1 ) );
		
		var lineDistance = this.attributes.lineDistance.array;		
		
		// для lineparts по идее так надо.. но почему-то общий метод в целом сам работает... одно что корни дважды вычисляет.. 
		/*
		for ( var i = 3, j=1, il = positions.length; i < il; i += 3*2, j+=2 ) {
		  vector.set( positions[ i ], positions[ i + 1 ], positions[ i + 2 ] );
		  vector_prev.set( positions[ i-3 ], positions[ i + 1-3 ], positions[ i + 2-3 ] );
		  lineDistance[ j ] = vector.distanceTo( vector_prev );
		  lineDistance[ j-1 ] = 0;
		}
		*/
		
		for ( var i = 0, j = 0, il = positions.length; i < il; i += 3, j += 1 ) {
  		vector.set( positions[ i ], positions[ i + 1 ], positions[ i + 2 ] );
  		if (i > 0) {
  		  d += vector.distanceTo( vector_prev );
  		}
  		lineDistance[ j ] = d;
  		vector_prev.set( positions[ i ], positions[ i + 1 ], positions[ i + 2 ] );
		}

		var attr = this.getAttribute("lineDistance");
    attr.needsUpdate = true;
}

WEBVR.getButtonPose = function ( display ) {
    
		var button = document.createElement( 'button' );
		button.style.position = 'absolute';
		button.style.left = 'calc(100% - 90px)';
		button.style.bottom = '20px';
		button.style.border = '0';
		button.style.padding = '8px';
		button.style.cursor = 'pointer';
		button.style.backgroundColor = '#000';
		button.style.color = '#fff';
		button.style.fontFamily = 'sans-serif';
		button.style.fontSize = '13px';
		button.style.fontStyle = 'normal';
		button.style.zIndex = '999';
		button.textContent = 'reset pose';
		button.onclick = function() {

			display.resetPose();

		};

		return button;

	};