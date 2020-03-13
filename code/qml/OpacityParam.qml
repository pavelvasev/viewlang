Param {
  id: param
  text: "Прозрачность"
  property var mult: 1
  guid: "opacity"
  
  value: 100
  
  property alias target: param.source
  property var source: parent
  onValueChanged: go();
  onSourceChanged: go();
  
  function go() {
    if (!source) return;
    source.opacity = mult * param.value/100.0;
    if (source["radiusChanged"])
      source.visible = source.radius > 0 && source.opacity > 0;
    else
      if (source.play)  // camera or video
      { // do nothing
      }
    else {
      source.visible = source.opacity > 0;
      //console.log("checked and set source.visible=",source.visible);
    }
  }
}