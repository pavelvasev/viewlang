import QtQuick 2.3
import QtQuick.Controls 1.2

// http://doc.qt.io/qt-5/qml-qtquick-controls-radiobutton.html
Item {
  property var text: ""
  property bool checked: false

  signal clicked();

  height: 30
//  width: 60

  /// internal

  id: radioButton
  
  property var htmlTagName: "label"
  
  onTextChanged: {
    if (htmlLabelSpan) htmlLabelSpan.innerHTML = radioButton.text;
    radioButton.implicitWidth = htmlLabelSpan.offsetWidth;
  }
  onCheckedChanged: if (htmlInput) htmlInput.checked = radioButton.checked;
  
  property var htmlInput
  property var htmlLabelSpan

  Component.onCompleted: {
    radioButton.dom.style.pointerEvents = "auto";
    radioButton.dom.innerHTML = '<input type="radio"/><span></span>';
    
    htmlInput = radioButton.dom.firstChild;
    htmlLabelSpan = radioButton.dom.lastChild;
    
    htmlInput.checked = radioButton.checked;
    htmlLabelSpan.innerHTML = radioButton.text;
    radioButton.implicitWidth = htmlLabelSpan.offsetWidth;

    /*
    htmlInput.onclick = function(e) {
        radioButton.checked = htmlInput.checked;
        radioButton.clicked();
    }*/
    
    htmlInput.addEventListener('click', function() {
      radioButton.checked = htmlInput.checked;
      radioButton.clicked();
    });
    
  }

}

