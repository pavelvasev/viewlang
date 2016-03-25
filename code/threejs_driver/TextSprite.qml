SceneObjectThreeJs { 
    id: obj

    property string text: ""

    property var texSize: [256,256]
    property var texOffset: centered ? [-0.5, 0.5] : [0,0] // [-0.25, 0.25] для центра
    property bool centered: false
    property var radius: 1

    property int pixelSize: 20
    property string family: "Georgia"
    property bool italic: false
    property bool bold: false

    property var fillColor: null // [1,1,1] или "cyan" или "rgba( 255, 0, 0, 0.55 )"
    property var borderColor: null // [0,0,0]

    color: [0,0,0] // цвет шрифта

    /////////////////

    property string fontString: (bold ? "Bold " : "") + (italic ? "Italic " : "")  + pixelSize + "px " + family

    onColorChanged: makeLater(this);
    onFillColorChanged: makeLater(this);
    onBorderColorChanged: makeLater(this);
    onFontStringChanged: makeLater(this);
    onRadiusChanged: makeLater( this );
    onVisibleChanged: makeLater( this );
    onTexSizeChanged: makeLater( this );
    onTexOffsetChanged: makeLater( this );
    onTextChanged: makeLater( this );

    //////////////////
    
    function make3d() {
      // удаляем невидимые тексты, чтобы не захламлять текстуры. Т.к. TextSprite используется в осях, а оси у нас в Scene, а Scene-ов может быть вложенных много.
      if (!visible) {
        clear();
        return;
      }

      prepare();

      var tx = obj.text;

      if (tx.length == 0) {
				this.canvas1.width = 0;
        this.canvas1.height = 0;
        this.texture1.needsUpdate = true;
        return;
      }

      var ts = texSize;
		  this.canvas1.width = ts[0];
      this.canvas1.height = ts[1];

      this.context1.clearRect( 0,0,ts[0],ts[1] );
      this.context1.font = fontString;

  		var metrics = this.context1.measureText(tx);
			var width = metrics.width;
			var height = pixelSize;

  		if (fillColor != null && fillColor != "") {
  			this.context1.fillStyle = color2css( fillColor );
  			this.context1.fillRect( 3,3, width+4+3,height+4 );
  		}
				
			if (borderColor != null) {
  			this.context1.strokeStyle = color2css( borderColor );
  			this.context1.strokeRect( 2,2, width+8+1,height+6);
  		}

 		  this.context1.fillStyle = color2css( color );
			this.context1.fillText( tx, 5+1, height );

			this.texture1.offset.set( texOffset[0], texOffset[1] ); 

			var r = radius;
      this.sceneObject.scale.set( r,r,r );

      this.texture1.needsUpdate = true;
    }

    function prepare() {
      if (this.sceneObject) return;

	    // create a canvas element
	    this.canvas1 = document.createElement('canvas');
	    this.context1 = canvas1.getContext('2d');

     	// canvas contents will be used for a texture
	    this.texture1 = new THREE.Texture(this.canvas1) 
	    this.texture1.minFilter = THREE.LinearFilter;
	    this.texture1.needsUpdate = true;
	
	    ////////////////////////////////////////
	
	    var spriteMaterial = new THREE.SpriteMaterial( { map: this.texture1 } );
	
	    this.sceneObject = new THREE.Sprite( spriteMaterial );
	    this.sceneObject.visible = visible;

	    threejs.scene.add( this.sceneObject );
      make3dbase();
    }
    
    function clear() {
      if (this.sceneObject) {
        scene.remove( this.sceneObject );
        if (this.sceneObject.geometry) this.sceneObject.geometry.dispose();
        if (this.sceneObject.material) this.sceneObject.material.dispose();
      }
      
      this.context1 = undefined;
      this.texture1 = undefined;
      this.canvas1 = undefined;
      
      this.sceneObject = undefined;
    }

    //////////////////////////////////////

    Component.onDestruction: {
      // место очистки - созданных dom и threejs объектов
      clear();
    }
}
