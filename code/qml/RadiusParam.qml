Param {
  id: param
  text: "radius"
  property var mult: 1
  
  value: 1
  max: 10
  
  property alias target: param.source  
  property var source: parent
  onValueChanged: go();
  onSourceChanged: go();
  
  function go() {
    if (!source) return;
    //source.radius = mult * param.value/100.0;
    source.radius = param.value
    source.visible = source.radius > 0;
    //console.log(source.radius);    
  }
}