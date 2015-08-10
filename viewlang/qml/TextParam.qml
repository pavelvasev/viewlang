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
  
  ParamUrlHashing {
    name: globalName
  }

  property var fastUpdate: false // update value as user type (do not wait for enter)
  
  property var globalName: scopeNameCalc.globalName
  property var globalText: scopeNameCalc.globalText
  ScopeCalculator {
    id: scopeNameCalc
    name: param.guid
    text: param.text
    // globalName, globalText
  }

  Text {
    id: toptext
    visible: param.text && param.text.length > 0
    text: param.text;
    Rectangle {
      color: param.color 
      z:-1
      width: parent.width
      y: parent.height-1
      height: param.color ? 2 : 0
    } 
  } //text
  
  TextInput {
    y: 2
    id: txt
    
    width: Math.max( param.width , 70 ) // 180
    text: param.value

    onAccepted: {
      param.value = text;
      console.log("hitted acc");
      param.accepted();
    }
    onTextChanged: {
      if (fastUpdate) param.value = text;
    }
  }

  onValueChanged: {
    txt.text = value;
  }
  
}  