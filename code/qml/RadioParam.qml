Column {
  id: param 

  property var text: title
  property var value: ""
  property var max: values.length

  property var values: []

  width: 180
  
  property var color
  property var guid: translit(text)

  property var tag: "left"

  ParamUrlHashing {
    name: globalName
  }

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

  // ExclusiveGroup { id: tabPositionGroup }
  Repeater {
    model: max

    RadioButton {
      text: param.values[index]
      //exclusiveGroup: tabPositionGroup
      onCheckedChanged: if (checked) param.value = index;
      id: bt
      Binding {
        target: bt
        property: "checked"
        value: param.value == index ? true : false
      }
    }
  }
  
}  