CheckBox {
  id: param

  property var value: 0

  property var min: 0
  property var max: 1
  property var step: 1

  property var tag: "left"

  onValueChanged: param.checked = (value == 1 || value == true);
  onCheckedChanged: param.value = checked ? 1 : 0

  property var guid: translit(text)

  property var enableAnimation: param.visible

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
  property alias scopeCalc: scopeNameCalc

  property alias paramAnimation: paramAnimationA
  ParamAnimation {
    id: paramAnimationA
    name: globalName
    text: globalText
    enabled: param.enableAnimation
//    enabled: false
  }
 
}