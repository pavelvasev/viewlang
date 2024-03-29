Column {
  id: param

  property var text: title
  property var value: ""
  property var title: ""

  width: 180
  
  property var color
  property var guid: translit(text)

  signal accepted(); // when user hit 'enter'
  
  property var tag: "left"
  property var sliderEnabled: false
  
  ParamUrlHashing {
    name: globalName
    id: hasher
  }
  property alias ahasher: hasher

  property var fastUpdate: false // update value as user type (do not wait for enter)
  
  property var globalName: scopeNameCalc.globalName
  property var globalText: scopeNameCalc.globalText

  ScopeCalculator {
    id: scopeNameCalc
    name: param.guid
    text: param.text
    // globalName, globalText
  }

  property bool colorizeText: true
  Text {
    id: toptext
    visible: param.text && param.text.length > 0
    text: param.text;
    Rectangle {
      visible: colorizeText
      color: param.color 
      z:-1
      width: parent.width
      y: parent.height-1
      height: param.color ? 2 : 0
    } 
  } //text
  
  property alias textInput: txt
  TextInput {
    y: 2
    id: txt
    
    width: Math.max( param.width , 70 ) // 180
    text: param.value

    onAccepted: {
      param.value = text;
      param.accepted();
      btEnter.visible = false;
    }

    property bool constructed: false
    Component.onCompleted: constructed = true;

    onTextChanged: {
      if (param.value == text) return;
      if (fastUpdate) {
        dontSetText = true;
        param.value = text;
        dontSetText = false;
      }
      else
        if (constructed) btEnter.visible = true;
    }
    
    Button {
      id: btEnter
      text: "OK"
      anchors.left: parent.right
      anchors.margins: 9
      visible: false
      onClicked: { txt.accepted(); }
    }
  }
  
  property bool dontSetText : false
  onValueChanged: {
    if (dontSetText) return;
    txt.text = value;
  }
  
}