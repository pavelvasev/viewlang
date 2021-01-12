Item {
    id: controls

    property var controlsTag: "bottom"
    
    property alias movieDialog: movieDlg
    Movie {
      id: movieDlg
    }


    Button {
        text: "Снимок экрана"
        width: 120
        property var tag: controlsTag

        onClicked: export1()

        function export1()
        {
            var img = renderer.domElement.toDataURL("image/png");

            var wnd = window.open( "about:blank", '_blank');
            wnd.document.body.innerHTML = "please wait..";
            jQuery.post( "//showtime.lact.in/update/visual?get_file_url=1&ext=png", { "imgbase64" : img }, function( res ) {
               wnd.location.href = "//showtime.lact.in" +res;
            });
        }
        
    }
    
    Button {
        text: "Камера 0"
        width: 100
        property var tag: controlsTag

        onClicked: {
          sceneObj.cameraControlC.reset();
        }
    }
    

    CheckBoxParam {
        id: axesBox
        text: "Оси"
        guid: "show_axes"
        checked: axes.visible && visible
        onCheckedChanged: axes.visible = checked;
        property var tag: controlsTag
        visible: controls.parent.isRoot
        enableAnimation: false
    }    

    property alias axes: axesA
    AxesC {
        id: axesA
        visible: false
        property bool enabled: controls.parent.isRoot
        //property var robotLayer: "system"

        onVisibleChanged: {
          if (controls.parent.isRoot && axesBox.checked != visible) {
            axesBox.checked = visible;
          }
        }
    }
    
    
    property var showMore: cbMore.checked
    CheckBox {
      id: cbMore
      text: "Доп."
      property var tag: controlsTag
    }

    Button {
        visible: showMore
        text: "Снимок 3D"
        property var tag: controlsTag
        width: 120

        onClicked: setFileProgress( "3d export","generating 3d json", 5, function() { export2() } );

        function export2()
        {
            console.log("so export 2...");
            var img = renderer.domElement.toDataURL("image/png");

            var output = scene.toJSON();
            output = JSON.stringify( output, null, '\t' );
            output = output.replace( /[\n\t]+([\d\.e\-\[\]]+)/g, '$1' );

            //jQuery.post( "http://www.svn.lact.ru:4567/update/visual?get_file_url=1", { "imgbase64" : img, "json":output }, function( res ) {
            //  window.open( "http://www.svn.lact.ru:4567" +res, '_blank');
            //});

            // выяснилось что rack ломается (регекспы его ломаются) при поступлении больших данных (25мб) в кодировке url-encoded
            // поэтому будем посылать в multipart/form-data

            setFileProgress( "3d export","sending to server",15);
            // как упаковываем -- http://stackoverflow.com/questions/5392344/sending-multipart-formdata-with-jquery-ajax
            var data = new FormData();
            data.append('imgbase64', img );
            data.append('json', output );


            var xhr = new XMLHttpRequest();
            xhr.open('POST', "http://www.svn.lact.ru:4567/update/visual?get_file_url=1");
            //xhr.responseType = 'text';
            
            xhr.onload = function(e) {
                var res = this.responseText;
                window.open( res.indexOf("://") >= 0 ? res : "http://www.svn.lact.ru:4567" + res, '_blank');
                setFileProgress( "3d export","done",-1);
            };

            xhr.onerror = function(e) {
                setFileProgress( "3d export","server error",-1);
            }

            xhr.upload.addEventListener("progress", function(e) {
                if (e.lengthComputable) {
                    setFileProgress( "3d export","sending to server",e.loaded / e.total * 100);
                }
            }, false);

            xhr.send(data);
            

            /*
           var jqxhr = jQuery.ajax({
         type: "POST",
         url: "http://www.svn.lact.ru:4567/update/visual?get_file_url=1",
             data: data,
             contentType: false, ///"multipart/form-data",
             processData: false,
         success: function(res) { window.open( res.indexOf("://") >= 0 ? res : "http://www.svn.lact.ru:4567" + res, '_blank'); },
         dataType: "text",
       }).done(function() {
              setFileProgress( "3d export","done",-1);
       }).fail(function() {
          setFileProgress( "3d export","server error",-1);
       });
       */

            /*        xhrFields: {
                    onprogress: function (e) {
                        if (e.lengthComputable) {
                          setFileProgress( "3d export","sending to server",e.loaded / e.total * 100);
                            //console.log(e.loaded / e.total * 100 + '%');
                      }
                  }
                */


        }

    }

    Button {
        visible: showMore
        text: "Экспорт в json"
        width: 120
        property var tag: controlsTag

        onClicked: {
            var output = scene.toJSON();
            output = JSON.stringify( output, null, '\t' );
            output = output.replace( /[\n\t]+([\d\.e\-\[\]]+)/g, '$1' );
            exportString( output );
        }

        function exportString ( output ) {
            var blob = new Blob( [ output ], { type: 'text/plain' } );
            var objectURL = URL.createObjectURL( blob );
            window.open( objectURL, '_blank' );
            window.focus();
        }

    }
    
    
    property var redGreenFocalValue: 0.064
    onRedGreenFocalValueChanged: {
      if (redGreenBox.redGreenEffect && redGreenBox.redGreenEffect.setFocalLength) 
        redGreenBox.redGreenEffect.setFocalLength( redGreenFocalValue );
    }
    CheckBox {
        id: redGreenBox
        visible: showMore || checked
        text: "Красно-синее"
        property var tag: controlsTag

        onCheckedChanged: {
            selectedRenderer = checked && this.redGreenEffect ? this.redGreenEffect : renderer;
            //       console.log(selectedRenderer);
        }
        
        ParamUrlHashing {
          name: "red-blue"
          property: "checked"
          enabled: parent.checked
        }

        Component.onCompleted: {
            //la_require("three.js-r/examples/js/effects/AnaglyphEffect.js", function() {
            la_require("AnaglyphEffect_patched.js", function() {
                redGreenBox.redGreenEffect = new THREE.AnaglyphEffect( renderer );
                redGreenBox.redGreenEffect.setSize( window.innerWidth, window.innerHeight );
                if (redGreenBox.redGreenEffect.setFocalLength) // типо в новом theejs нету этого метода
                  redGreenBox.redGreenEffect.setFocalLength( redGreenFocalValue ); 	
                checkedChanged();
            } );
        }
        
    }
    Param {
      visible: redGreenBox.checked
      id: param
      value: redGreenFocalValue
      text:""
      guid: "focal_length"
      property var tag: "bottom"      
      height: 20
      step: 0.001
      min: 0
      max: 0.2
      comboEnabled: false
      textEnabled: true 
      onValueChanged: if (visible) redGreenFocalValue = param.value
    }    

    CheckBox {
        id: cbStereo
        visible: showMore
        text: "Стерео"
        property var tag: controlsTag

        onCheckedChanged: {
            if (checked) {
                if (!this.stereoEffect) {
                    this.stereoEffect = new THREE.StereoEffect( renderer );
                    this.stereoEffect.eyeSeparation = 1;
                    this.stereoEffect.setSize( window.innerWidth, window.innerHeight );
                }
                if (this.stereoEffect) {
                    selectedRenderer = this.stereoEffect;
                    // goFullScreen();
                }
            }

            if (!checked || !this.stereoEffect) {
                selectedRenderer = renderer;
                threeJsWindowResize();
            }
        }

        // по уму их тут и надо загружать.. а то чего распластались..
        Component.onCompleted: {
            la_require("three.js-part/examples/js/effects/StereoEffect.js");
        }

    }

    OculusControl2 {
        visible: showMore
        property var tag: controlsTag
    }

    Stats {
        property var tag: controlsTag
        visible: showMore
    }

    ////////////////////



   CheckBox {
    text: "OSC"
    property var tag: "bottom"
    id: thecheck
    visible: isRoot && driverControls.showMore
    checked: sceneObj.oscManager.enabled
    onCheckedChanged: sceneObj.oscManager.enabled = checked;

        ParamUrlHashing {
          name: "osc"
          property: "checked"
          enabled: parent.checked
        }
  }    

  
  /* редко используемая фича
    Text {
        visible: showMore
        y: 2
        property var tag: controlsTag
        text: "  <a href='" + (loadedSourceFile||"") + "' target='_blank'>Исходный код</a>"
    }
  */

    Text {
        visible: showMore
        y: 2
        property var tag: controlsTag
        text: "  <a href='' target='_blank' onclick='this.href=\"http://tinyurl.com/create.php?url=\"+encodeURIComponent(location.href)'>TinyURL!</a>"
    }    


      
}
