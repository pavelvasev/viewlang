//import QtQuick 2.3
//import QtQuick.Controls 1.2

// http://doc.qt.io/qt-5/qml-qtquick-controls-radiobutton.html
// exclusiveGroup is a string for now
// For valid implementation of excl group refer to: 
// * http://doc.qt.io/qt-5/qml-qtquick-controls-exclusivegroup.html
// * https://qt.gitorious.org/qt/qtquickcontrols/source/09a74592234c84b3e428b452d844eaa1f6451040:src/controls/qquickexclusivegroup.cpp

Item {
  property var text: ""
  property bool checked: false

  signal clicked();

  property var exclusiveGroup
  property var exclusiveGroupName: exclusiveGroup ? exclusiveGroup.name : null
  
  height: Math.max( txt.implicitHeight+3, 20 )
  width: 25 + txt.implicitWidth

  /// internal
  property var exclusiveGroupConnected
  onExclusiveGroupChanged: {
    if (exclusiveGroupConnected) exclusiveGroupConnected.unbindCheckable( radioButton);
    if (exclusiveGroup)  exclusiveGroup.bindCheckable( radioButton );
    exclusiveGroupConnected = exclusiveGroup;
  }

  Component.onDestruction: exclusiveGroup = null;

  id: radioButton
  
  property var htmlTagName: "label"

  Item {
    property var htmlTagName: "input"
    id: inp
  }

  Text {
    y: 2
    x: 20
    id: txt
    text: radioButton.text
  }
  
  onCheckedChanged: if (inp) inp.dom.checked = radioButton.checked;
  
  Component.onCompleted: {
    // prepare group id
    if (!exclusiveGroup) {
      if (!radioButton.parent.exclusiveGroupName) {
        if (!window.radioButtonExclusiveGroupCounter) window.radioButtonExclusiveGroupCounter = 0;
        radioButton.parent.exclusiveGroupName = "excl_group_" + (window.radioButtonExclusiveGroupCounter++);
      }
      
      exclusiveGroupName = radioButton.parent.exclusiveGroupName;
    }
    
    radioButton.dom.style.pointerEvents = "auto";
    
    inp.dom.type = "radio";
    inp.dom.name = exclusiveGroupName;
    
    inp.dom.addEventListener('click', function() {
      radioButton.checked = inp.dom.checked;
      radioButton.clicked();
    });
    
  }

}

