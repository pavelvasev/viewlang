import QtQuick.Controls 1.2

Column {
  id: param

  property var text: title
  property var title
  property var value:min
  property var min:0
  property var max:100
  property var step:1

  // http://habrahabr.ru/post/250885/#comment_8294577
  property var guid: translit(text)

  function translit(text) {
            return text.replace(/([а-яё])|([\s_-])|([^a-z\d])/gi,
                function (all, ch, space, words, i) {
                    if (space || words) {
                        return space ? '-' : '';
                    }
                    var code = ch.charCodeAt(0),
                        index = code == 1025 || code == 1105 ? 0 :
                            code > 1071 ? code - 1071 : code - 1039,
                        t = ['yo', 'a', 'b', 'v', 'g', 'd', 'e', 'zh',
                            'z', 'i', 'y', 'k', 'l', 'm', 'n', 'o', 'p',
                            'r', 's', 't', 'u', 'f', 'h', 'c', 'ch', 'sh',
                            'shch', '', 'y', '', 'e', 'yu', 'ya'
                        ];
                    return t[index];
                });
        }
  
  property var enableSliding: !bigCase
  property bool bigCase: (param.max - param.min) / param.step > 10000

  property var values
  
  ////////////////

  property var comboEnabled: !bigCase
  property var textEnabled: bigCase

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
    //console.log("value changed to ",value, param.text);
    //debugger;
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
  
  Text {
    visible: param.text && param.text.length > 0
    text: param.text  + " = " + (values && values[value] && values[value] != value ? values[value] +" ["+value+"]": value)  
    
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
  
  Slider {
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
    
    model: generate()
    width: 50
    
    anchors.right: parent.right
    
    function generate() {
      if (!enabled) return [];
      var acc = [];
      var i = param.min;
      var maxco = 100*1000;
      var pmax = param.max;
      var pstep = param.step;
      while (i <= pmax && maxco-- > 0) {
        acc.push(i); i+=pstep;
      }
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
    name: param.guid
  }
 
  property alias paramAnimation: paramAnimationA
  ParamAnimation {
    id: paramAnimationA
    name: param.guid
  }
  
}
