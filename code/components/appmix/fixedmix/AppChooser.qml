// import components.distort

// Важное пояснение. Тут ниже много где используется слово "shader". 
// На самом деле это надо воспринимать как "приложение", "объект" или "компонент".
// А шейдер оно потому, что изначально это делалось для загрузки шейдеров.

Scene {
  id: scen
  
  property var ctag: "right"
  property var scopeName: "fixedmix"
  property var text: ""  
  
  property var apps: []

  property alias app: obj

  signal appLoaded( object app );  

  Text {
    text: scen.text
    property var tag: scen.ctag
  }

//  property var urlas: [] // ["Denis3.qml","ExampleShader.qml"]
  property var urlas: {
    var res = [];
    for (var i=0; i<apps.length; i++) {
        var s = apps[i];
        var qdirInfo = engine.qmldirs[ s ]; 
        if (qdirInfo) 
          s = qdirInfo.url;
        res.push( s );
    }
    return res;
  }

  property var urlasWithBlank: ["---"].concat( urlas )
  property var appsWithBlank: ["---"].concat( apps )  
  property var objectParent: scen // paramPlace

  property alias selectedNumber: pShader.value // нумерация с 1
  
  Row {
    property var tag: ctag
    spacing: 5
    
    ComboBoxParam {
        //width: 100
        tag: undefined
        id: pShader
        guid: "appname"
        values: appsWithBlank.map( function(e,index) { return (edited[urlasWithBlank[index]] ? "*" : "")+e } );
    }

    Button {
        text: "Edit"
        onClicked: openDlg();
    }
  }
  
  property alias paramPlace: paramPlaceA
  Column {
    id: paramPlaceA
    property var tag: ctag	
  }
  
  property var edited: { return {}; }
    
 // property var shaderUrl: Qt.resolvedUrl( pShader.values[ pShader.value ] + ".qml" )

  property var shaderUrl: Qt.resolvedUrl( urlas[ pShader.value-1 ] )
  property var codes: { return {}; }
  property var shaderCode: ""
  property var originalShaderCode

  ParamScopedUrlHashing {
    name: "editedCode"
    property: "shaderCodePatchEncoded"
    enabled: edited[urlasWithBlank[ pShader.value ]]
  }
  property var shaderCodePatchEncoded

  onShaderCodePatchEncodedChanged: {
    var shaderCodePatch = decodeURIComponent( shaderCodePatchEncoded )
    if (shaderCodePatch != shaderCode) {
      console.log("i assign patch",shaderCodePatch);
      codes[ shaderUrl ] = shaderCodePatch;
      edited[urlasWithBlank[ pShader.value ]] = true;
      shaderCode = shaderCodePatch;
      editedChanged();
      codesChanged();
    }
  }
  
  property var xhr
  onShaderUrlChanged: {

    var r = codes[ shaderUrl ];
    if (typeof(r) !== "undefined") {
      // есть в кэше
      shaderCode = r;
      return;
    }
    var url = shaderUrl;
    //console.log("i invoke load of shader shaderUrl=",shaderUrl);
    if (xhr && xhr.abort) xhr.abort();

    xhr = loadFile( url, function (content) {
      if (edited[urlasWithBlank[ pShader.value ]]) return;
      //console.log("i assign code",content);
      codes[ url ] = content;
//      shaderUrl = url;
      shaderCode   = content;
      xhr = undefined;

//      originalShaderCode = content;
    }, function(err) {
      if (edited[urlasWithBlank[ pShader.value ]]) return;
      var content = "";
      codes[ url ] = content;
      shaderCode   = content;
      xhr = undefined;      
//      originalShaderCode = content;      
    });
  }

  onShaderCodeChanged: {
    applyCode();
  }
  
  property var obj
  property alias shader: scen.obj

  function applyCode()
  {
    //console.log( "applyCode called! shaderCode=",shaderCode);
    //debugger;
    if (obj && obj.destroy) obj.destroy();
    if (shaderCode && shaderCode.length > 0) {
      obj = Qt.createQmlObject( shaderCode, objectParent, shaderUrl, __executionContext )
      
//      scen.walkChildren( obj, function (c) {
//        if (c.tag) c.tag = "right";
//      });

      scen.refineAll();
      scen.appLoaded(obj);
    }
    shaderCodePatchEncoded = encodeURIComponent( shaderCode )
  }  

/*
  Binding {
    target: parent
    property: "shaderCode"
    value: jlo.output 
  }
  
  property var shaderCode
  property alias shaderCodeOrig: jlo.output  
  property alias sh: obj
  property alias shader: obj

  onShaderCodeChanged: applyCode();
  ////property var obj: 17
  
  onObjChanged: {
    //console.log("alarm!");
    //debugger;
  }
  
  ParamScopedUrlHashing {
    name: "shaderCode"
    property: "shaderCode"
//    enabled: !shaderCode ? true : shaderCode != shaderCodeOrig
    enabled: shaderCode != shaderCodeOrig
  }
*/
  
  function openDlg()
  {
    tx.text = codes[ shaderUrl ];
    dlg1.open();
  }

  SimpleDialog {
    id: dlg1
    width: parent.width * 0.5
    height: parent.height * 0.5
    title: "Edit code"

    TextEdit {
      width: parent.width
      height: parent.height - 30	
      id: tx
    }

    Button {
      text: "Enter"
      anchors.bottom: dlg1.bottom
      anchors.margins: 5
      onClicked: {
        dlg1.close();
        codes[ shaderUrl ] = tx.text;
        edited[ urlasWithBlank[ pShader.value ] ] = true;
        scen.editedChanged();
        shaderCode = tx.text;
      }
    }
  
  } // dlg

}
