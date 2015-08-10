Param {
  id: param
  text: "Прозрачность"
  property var mult: 1
  
  value: 100
  
  property alias target: param.source
  property var source: parent
  onValueChanged: go();
  onSourceChanged: go();
  
  function go() {
    if (!source) return;
    source.opacity = mult * param.value/100.0;
    source.visible = source.radius > 0 && source.opacity > 0;
  }
}