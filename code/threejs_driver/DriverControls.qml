Item {
    id: controls

    property var controlsTag: "bottom"
    
    property alias movieDialog: movieDlg
    Movie {
      id: movieDlg
    }


    Button {
        text: "Скриншот"
        property var tag: controlsTag

        onClicked: export1()

        function export1()
        {
            var img = renderer.domElement.toDataURL("image/png");

            jQuery.post( "http://www.svn.lact.ru:4567/update/visual?get_file_url=1", { "imgbase64" : img }, function( res ) {
                window.open( "http://www.svn.lact.ru:4567" +res, '_blank');
            });
        }
        
    }

    CheckBoxParam {
        id: axesBox
        text: "Оси"
        guid: "show_axes"
        checked: axes.visible
        onCheckedChanged: axes.visible = checked;
        property var tag: controlsTag
        visible: controls.parent.isRoot
        enableAnimation: false
    }    

    property alias axes: axesA
    AxesC {
        id: axesA
        visible: false
        onVisibleChanged: {
          if (controls.parent.isRoot === false) axesBox.checked = false;
        }
    }
    
    
    property var showMore: cbMore.checked
    CheckBox {
      id: cbMore
      text: "Дополнительно"
      property var tag: controlsTag
    }

    Button {
        visible: showMore
        text: "Скриншот 3D"
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
    
    
    property var redGreenFocalValue: 25
    onRedGreenFocalValueChanged: {
      if (redGreenBox.redGreenEffect) 
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
            //        console.log("loading anagl");
            la_require("three.js/examples/js/effects/AnaglyphEffect.js", function() {
                //	        console.log("anagl loaded");
                redGreenBox.redGreenEffect = new THREE.AnaglyphEffect( renderer );
                redGreenBox.redGreenEffect.setSize( window.innerWidth, window.innerHeight );
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
                    goFullScreen();
                }
            }

            if (!checked || !this.stereoEffect) {
                selectedRenderer = renderer;
                threeJsWindowResize();
            }
        }

        // по уму их тут и надо загружать.. а то чего распластались..
        Component.onCompleted: {
            la_require("three.js/examples/js/effects/StereoEffect.js");
        }

    }
    
    OculusControl {
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

  
    Text {
        visible: showMore
        y: 2
        property var tag: controlsTag
        text: "  <a href='" + (loadedSourceFile||"") + "' target='_blank'>Исходный код</a>"
    }

    Text {
        visible: showMore
        y: 2
        property var tag: controlsTag
        text: "  <a href='' target='_blank' onclick='this.href=\"http://tinyurl.com/create.php?url=\"+encodeURIComponent(location.href)'>TinyURL!</a>"
    }    


      
}
