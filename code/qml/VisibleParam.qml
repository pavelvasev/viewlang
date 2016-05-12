CheckBoxParam {
  id: param
  property var source: parent
  property alias target: param.source
  text: "Отображать"
  checked: true
  width: 150

  onCheckedChanged: go();
  onSourceChanged: go();
  
  function go() {
    if (!source) return;
    source.visible = param.checked;
  }

}