TextParam {

  id: t
  text: "Цвет"
  width: 100
  guid: "color"
  
  property var spath: Qt.resolvedUrl( "jscolor/jscolor.js" );
  Component.onCompleted: {
    la_require( spath, function () {
      //console.log( t.textInput.dom.firstChild );
      
      t.inputDom = t.textInput.dom.firstChild;
      t.picker = new jscolor.color(t.inputDom, {})
      // todo переписать на работу с массивом a,b,c t.fromString = 
      var origP = t.picker.fromString;
      t.picker.fromString = function(hex, flags) {
        if (!hex || !hex.split || !hex.match) return false;
        if (origP.apply(t.picker, [hex,flags])) return true;
        var v = hex.split(" ");
        //console.log(v);
        if (v.length < 3) return false;
        this.fromRGB( parseFloat(v[0] || 1),parseFloat(v[1] || 1),parseFloat(v[2] || 1),flags );
        return true;
      }
      t.picker.toString = function(hex, flags) {
        return Number(this.rgb[0].toFixed(2)) + " " + Number(this.rgb[1].toFixed(2)) + " " + Number(this.rgb[2].toFixed(2));
        //return this.rgb[0] + " " + this.rgb[1] + " " + this.rgb[2];
      }      
      
      t.picker.onImmediateChange = function() { if (fastUpdate) t.inputDom.oninput(); };
      t.picker.onChange = function() { t.inputDom.oninput(); };
      t.picker.fromString(t.value);
    } );
  }

  colorizeText: false
  
  property var color: [1,0,0]
  //targetHasColor() ? target.color : [1,0,0]

  fastUpdate: true

  function targetHasColor() {
    return t.target && target["colorChanged"] ? true : false;
  }

  property bool colorWasChanged: false

  onColorChanged: {
    colorWasChanged = true;
    //console.log("ColorParam: color changed",color, "targetHasColor()=",targetHasColor(),"t.doNotSendBack=",t.doNotSendBack, "t.target=",t.target );
    if (!t.doNotSendBack) {
      // console.log("setting value to color=",color);
      value = color.join(" ");
      //t.picker.fromString(t.value);
      
    }
    if ( targetHasColor() )
    {
      //debugger;
      //console.log("setting color to target,",color);
      target.color = color;
    }
  }

  onValueChanged: {
    //console.log(value);
    if (!value || !value.split) return;
    t.doNotSendBack = true;
    color = value.split(" ").map( function(e) { return parseFloat(e) } );
    if (t.picker) t.picker.importColor();
    t.doNotSendBack = false;
  }
 
  property alias target: t.source
  property var source: parent

  onSourceChanged: {
    //console.log("onSourceChanged... targetHasColor=",targetHasColor() );
    if (colorWasChanged && targetHasColor()) target.color = color;
  }
}