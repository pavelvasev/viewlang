/* Предназначение - универсальный числовой параметр.

   Может работать в 2х режимах -
   1. Просто числа - тогда min,max,step,value это обычно-понимаемые вещи
   2. Список значений заданный в values - тогда min=0, max=values.length-1, value= индекс в values, step=1
   при этом элементы values могут быть и строками, и числами.
   
   Примечание. Встроенный combo-box научен сопровождать оба режима.
*/

import QtQuick.Controls 1.2

Column {
    id: param

    property var text: title
    property var title
    property var value:min
    // в случае combobox значений заданных через values, value это номер от min до min+values.length
    property var min:0
    property var max:100
    property var step:1

    property var guid: translit(text)

    property var enableSliding: !bigCase
    property bool bigCase: (param.max - param.min) / param.step > 1000 || (!computeMaxFromValues && values && values.length < max)

    property var values

    property bool computeMaxFromValues: true

    ////////////////

    property var comboEnabled: !bigCase
    property var textEnabled: bigCase

    property var sliderEnabled: true
    property var valEnabled: !comboEnabled
    //property var textLeft: false
    
    //property var valuesMode: Array.isArray( values )

    onValuesChanged: {
        if (values && values.length > 0) {
            if (min > 0) min = 0; // оставим возможность задать -1
            //min = 0;

            if (computeMaxFromValues) max = values.length - 1;
            step = 1;
            //combo.model = values;
        }
        // представитель алгоритма setAppValue
        valuesAreSortedChecked=false;
        updateControlsFromValue();
    }

    property var tag: "left"

    signal changed(int newvalue, object event);

    onValueChanged: updateControlsFromValue()
    onMinChanged: updateControlsFromValue()
    onStepChanged: updateControlsFromValue()

    function updateControlsFromValue() {
        //@ console.log("param value changed to ",value ); //, param.text);
        //if (param.text && param.text.indexOf(" t") > 0)
        //    debugger;
        //@ console.log(" => i set slider to",value);
        slider.value = value;
        if (comboEnabled || typeof(comboEnabled) === "undefined" ) { // тк.. может быть еще не расчитано
            var nci = Math.round( (value - min) / step ); // тут был floor и это давало несовпадение
            //@ console.log(" => i set combo to",nci,param.min,value);
            combo.traceChangeEnabled = false; // шобы оно обратно не рассчитывало
            combo.currentIndex = nci;
            combo.traceChangeEnabled = true;
        }
        else
        {
          txt.updatetext();
        }
    }

    //spacing: 2
    //anchors.topMargin: 15

    property var color //:"red"

    //  Item {
    //    width: 170 //parent.width
    //spacing: 5
    //    height: 20

    function par2s(val) {
        if (value && value.toFixed) return Number(value.toFixed(3));
        return value;
    }

    Text {
        id: toptext
        visible: param.text && param.text.length > 0

        //parent: therow
        text: {
            if (valEnabled) {
                if (!values) 
                    return param.text  + " = " + par2s(value);

                var val = values[ value - param.min ]

                if (val && val != value)
                    return param.text  + " = " + val; // нафиг этот N, ток мозги парит +" [№"+par2s(value)+"]";

                return param.text  + " = " + par2s(value)
            }
            return param.text;
        }

        Rectangle {
            color: param.color
            z:-1
            width: parent.width
            y: parent.height-1
            height: param.color ? 2 : 0
        } //rect
    } //text

    Row {
        spacing: 5
        id: therow

        Slider {
            visible: sliderEnabled

            id: slider
            minimumValue: param.min
            maximumValue: param.max
            stepSize: param.step
            updateValueWhileDragging : param.enableSliding
            //value: param.value
            onValueChanged: {
                if (isNaN(slider.value)) {
                  //debugger;
                  return; // special case.. sometimes it is nan...
                }
                //console.log("Slider val changed! param.value = ",param.value,"slider.value=",slider.value);
                //if (slider.value == 0.85 && param.value == 0.8500000000000001) debugger;
                if (param.value != slider.value) {
                    //console.log(" =>... setting param.value to slider.value",slider.value);
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
            text: gettext()
            function updatetext() {
              text = gettext();
            }
            
            function gettext() { // in values mode, return value!
              if (param.values) return param.values[ param.value ];
              return param.value;
            }

            onAccepted: {
                var v = parseFloat( text );
                if (isNaN(v)) v = param.min;

                if (param.values) { // in values mode, value is entered (not index)
                  var nearest_i = -1;
                  var nearest_dist = 1e10;
                  var vals = param.values;
                  for (var i=0; i<vals.length; i++) {
                    var d = Math.abs( vals[i] - v );
                    if (d < nearest_dist) {
                      nearest_dist = d;
                      nearest_i = i;
                      if (d <= 0) break;
                    }
                  }
                  v = nearest_i;
                }

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

                if (enabled && traceChangeEnabled) {
                  var nv = param.min + currentIndex * param.step;
                  nv = Number( nv.toFixed( 7 ) ); /// такое вот округление. А то оно выдает загадочные числа 0.150000000001
                  //@ console.log(" combo currentIndex changed! currentIndex=",currentIndex," => new value = ",nv, "setting it to param.value." );
                  if (nv != param.value) param.value = nv;
                }
            }
            property bool traceChangeEnabled: true

            checkCurrentIndex: false

            model: generate()
            width: 70

            anchors.right: parent.right

            function generate() {
                if (!enabled) return [];
                if (param.values && param.values.length > 0) return param.values;

                var acc = [];

                var maxco = 1000;
                var pmax = param.max;
                var pstep = param.step;
                var pmin = param.min;

                var count = (pmax - pmin)/pstep;
                if (count > maxco) { bigCase=true; return []; }

                for (var k=0; k<=count; k++) {
                    var v = pmin + k * pstep;
                    acc.push( Number( v.toFixed( 7 ) ) );
                    // обрываем все что было после N знаков при отображении
                    // иначе на экране будут числа вида 15.0000000001 иногда
                }

                /* корявый метод, округление сбоит
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

    ParamUrlHashing {
        name: globalName
        id: hasher
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
    property alias ahasher: hasher
    
    //////////////////////////////////////// setAppValue
    
    
    /// установка значений из списка
    function closestForSorted(num, arr) {
      var mid;
      var lo = 0;
      var hi = arr.length - 1;
      while (hi - lo > 1) {
        mid = Math.floor ((lo + hi) / 2);
        if (arr[mid] < num) {
          lo = mid;
        } else {
          hi = mid;
        }
      }
      if (num - arr[lo] <= arr[hi] - num) {
        return lo;
      }
      return hi;
    }
    
    function closestForUnsorted(num, arr) {
      var nearest_i=undefined;
      var nearest_dist = 10000000;
      for (var i=0; i<arr.length; i++) {
        var dist = Math.abs( arr[i] - num );
        if (dist < nearest_dist) {
          nearest_i = i;
          nearest_dist = dist;
        }
      };
      return nearest_i;
    }

    function isSorted(arr){
      if (!arr) return false;
      for (var i=1; i<arr.length; i++) {
        if (!(arr[i-1] < arr[i])) return false;
      }
      return true;
    }
    
    // кеш
    property bool valuesAreSortedChecked: false
    property bool valuesAreSorted: false
    
    function setAppValue( v )
    {
      if (values && values.length > 0)
      {
        var q = values;
        if (typeof(v) == "String")
          value = q.indexOf( v );
        else
        {
          if (!valuesAreSortedChecked) {
            valuesAreSorted = isSorted(values);
            valuesAreSortedChecked=true;
          }
          if (valuesAreSorted)
            value = closestForSorted( v, values );
          else
            value = closestForUnsorted( v, values );
        }
      }
      else
        value = v;
    }
}
