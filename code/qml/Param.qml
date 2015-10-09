import QtQuick.Controls 1.2

Column {
  id: param

  property var text: title
  property var title
  property var value:min
  property var min:0
  property var max:100
  property var step:1

  property var guid: translit(text)
  
  property var enableSliding: !bigCase
  property bool bigCase: (param.max - param.min) / param.step > 10000

  property var values
  
  ////////////////

  property var comboEnabled: !bigCase
  property var textEnabled: bigCase

  property var sliderEnabled: true
  property var valEnabled: true
  property var textLeft: false

  onValuesChanged: {
    if (values && values.length > 0) {
      min = 0;
      max = values.length -1;
      step = 1;
      combo.model = values;
    }
  }

  property var tag: "left"
  
  signal changed(int newvalue, object event);
  
  onValueChanged: updateControlsFromValue()
  onMinChanged: updateControlsFromValue()
  onStepChanged: updateControlsFromValue()

  function updateControlsFromValue() {
    //console.log("param value changed to ",value, param.text);
    //if (param.text && param.text.indexOf(" t") > 0)
    //    debugger;
    slider.value = value;
    if (comboEnabled || typeof(comboEnabled) === "undefined" ) { // тк.. может быть еще не расчитано
      combo.currentIndex = Math.floor( (value - min) / step );
      //console.log("i set combo to",combo.currentIndex,param.min,value);
    }
    else
      txt.text = value;
  }
  
  //spacing: 2
  //anchors.topMargin: 15
  
  property var color //:"red"

//  Item {
//    width: 170 //parent.width
    //spacing: 5
//    height: 20

  function par2s(val) {
    if (value.toFixed) return Number(value.toFixed(3));
    return value;
  }
  
  Text {
    id: toptext
    visible: param.text && param.text.length > 0

    //parent: therow
    text: {
      if (valEnabled)
        return param.text  + " = " + (values && values[value] && values[value] != value ? values[value] +" [№"+par2s(value)+"]": par2s(value))  
      return param.text;
    }
    
//    color: "green"
//    styleColor: "gray"
//    styleColor: param.styleColor
//    style: param.styleColor ? 2 : null
  Rectangle {
    color: param.color 
    z:-1
    width: parent.width
    y: parent.height-1
    height: param.color ? 2 : 0
//    anchors.fill:parent
//    width: parent.width
//    height : param.color ? 5 : 0
    //anchors.marginTop: 10
    
  } //rect
  } //text

  Row {
  spacing: 5
  id: therow
  
  /*
  Text {
    id: lefttext
    y: 3
    visible: textLeft && param.text && param.text.length > 0
    text: visible ? param.text : ""
  }
  */
  
  Slider {
    visible: sliderEnabled

    id: slider
    minimumValue: param.min
    maximumValue: param.max
    stepSize: param.step
    updateValueWhileDragging : param.enableSliding
    //value: param.value
    onValueChanged: {
      if (param.value != slider.value) {
        param.value = slider.value;
      }
    }
  } // slider

  
  TextInput {
    visible: param.textEnabled
    y: 2
    id: txt

    width: 50
    anchors.right: parent.right
    text: param.value

    onAccepted: {
      var v = parseFloat( text );
      if (isNaN(v)) v = param.min;

      param.value = v;
    }
  }
  

  ComboBox {
    property bool enabled: param.comboEnabled
    visible: enabled
    y: 2
    id: combo
    onCurrentIndexChanged: {
      if (qmlEngine.operationState === QMLOperationState.Init || qmlEngine.operationState === QMLOperationState.Idle) return;

      if (enabled)
        param.value = param.min + currentIndex * param.step;
    }
    
    checkCurrentIndex: false

    model: generate()
    width: 70
    
    anchors.right: parent.right
    
    function generate() {
      if (!enabled) return [];
      var acc = [];
      
      var maxco = 100*1000;
      var pmax = param.max;
      var pstep = param.step;
      var pmin = param.min;

      var count = (pmax - pmin)/pstep;
      // acc.push( param.min );
      for (var k=0; k<=count; k++) {
        var v = pmin + k * pstep;
        acc.push( Number( v.toFixed( 7 ) ) ); 
        // обрываем все что было после N знаков при отображении
        // иначе на экране будут числа вида 15.0000000001 иногда
      }
      /*
      var i = param.min;
      while (i <= pmax && maxco-- > 0) {
        acc.push(i); i+=pstep;
      }
      */
      return acc;
    }
  }

  } //row

  Component.onDestruction: {
    //console.log( "param removing",param.dom );
    ///jQuery( param.dom ).remove();
    //param.parent = undefined;
    //debugger;
  }

  Component.onCompleted: {
    //console.log("param created,",param.dom);
    /*
    debugger;
    if (param.parent && param.parent.layoutChildren)
      param.parent.layoutChildren();
    */
  }
  
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
 
  property alias paramAnimation: paramAnimationA
  ParamAnimation {
    id: paramAnimationA
    name: globalName
    text: globalText
  }
  
  property alias acombo: combo
  property alias aslider: slider
  property alias atoptext: toptext  
  //property alias alefttext: lefttext
  property alias arow: therow
}
