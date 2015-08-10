//import QtQuick 2.3
//import QtQuick.Controls 1.2

//http://doc.qt.io/qt-5/qml-qtquick-controls-progressbar.html
//https://developer.mozilla.org/ru/docs/Web/HTML/Element/progress
Item {
  width: 120 // 160x16 is a default size in chrome
  height: 16

  id: progress

  property real value: 0
  property real maximumValue :1
  property real minimumValue :0
  property bool indeterminate: false
  
  // internal
  property var htmlTagName: "progress"
  
  onValueChanged: updateDom();
  onIndeterminateChanged: updateDom();
  
  function updateDom() {
    if (indeterminate)
      progress.dom.removeAttribute("value");
    else
      progress.dom.value = value;
  }
      
  
  onMaximumValueChanged: {
    progress.dom.max = maximumValue;
  }

}
