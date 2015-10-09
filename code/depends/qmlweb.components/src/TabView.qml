
// http://doc.qt.io/qt-5/qml-qtquick-controls-tabview.html
// uses RadioButton for tabs view

/* TODO

*/

Item {
  id: tabview
  //property var contentItem: tabview

  property var currentIndex: undefined
  property var count: contentItem.children.length
  
  property alias contentItem: content
  default property alias newChildren: content.data

  function getTab( index ) {
    return tabsArr[index];
  }

  function filterVisuals(arr) {
    var res = [];
    for (var i=0; i<arr.length; i++) {
      if (arr[i] instanceof QMLRepeater) continue;
      res.push( arr[i] );
    }
    return res;
  }

  property var tabsArr: filterVisuals( content.children )
  
  Item {

  anchors.fill: parent
  
  Flow {
    width: parent.width
    id: buttons
    spacing: 2
    Repeater {
      parent: tabview 
      model: tabsArr.length
      delegate: RadioButton {
        // text: modelData.title
        text: {
          var qq= tabsArr[ ritem.index ]
          //debugger;
          return tabsArr[ ritem.index ].title || tabsArr[ ritem.index ].text || ("Tab "+ritem.index)
        }
        id: ritem
        // Component.onCompleted: console.log("Added an element (index: " + item.index + ")");
        onClicked: tabview.currentIndex = ritem.index
      }
    }

  }

  Item {
        x: 2
        y: 2 + buttons.height
        width: tabview.width
        height: tabview.height - buttons.height - 2

        id: content
  }

  }
  
  /* 
  Component.onCompleted: {
       // https://github.com/toddmotto/data-tabs/blob/master/index.html
       //   http://codepen.io/CesarGabriel/pen/nLhAa -- еще круче  
    
    var aa = "";
    for (var i=0; i<content.children.length; i++) {
      var tab = content.children;
      jQuery( tab.dom ).data( "data-content",i );
      aa = aa + '<a href="#" data-tab="' + i + '" class="tab">' + (tab.title || tab.text || 'Tab '+i) + '</a>';
    }
    jQuery( tabview.dom ).prepend( aa );
  }
  */
  
  onCurrentIndexChanged: {

    for (var i=0; i<content.children.length; i++) {
      content.children[i].visible = false;
      // buttons.children[i].text = content.children[i].title || content.children[i].text || ("Tab "+i);
    }

    if (content.children.length > 0) {
      content.children[currentIndex].visible = true;
      buttons.children[currentIndex].checked = true; //// text = "<strong>" + buttons.children[currentIndex].text + "</strong";
    }

  }

  Component.onCompleted: {
    if (typeof(tabview.currentIndex)==="undefined") 
      tabview.currentIndex = 0; 
    else 
      tabview.currentIndexChanged();
  }
  
}