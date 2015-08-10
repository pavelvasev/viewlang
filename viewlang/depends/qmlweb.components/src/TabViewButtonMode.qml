
// http://doc.qt.io/qt-5/qml-qtquick-controls-tabview.html

Item {
  id: tabview
  //property var contentItem: tabview

  property var currentIndex
  property var count: contentItem.children.length
  
  property alias contentItem: content
  default property alias newChildren: content.data

  Item {

  anchors.fill: parent
  
  Row {
    id: buttons
    spacing: 2
    Repeater {
      parent: tabview 
      model: content.children.length
      delegate: Button {
        // text: modelData.title
        // text: content.children[ item.index ].title
        id: item
        // Component.onCompleted: console.log("Added an element (index: " + item.index + ")");
        onClicked: tabview.currentIndex = item.index
      }
    }

  }

  Item {
        x: 2
        y: 22
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
      buttons.children[i].text = content.children[i].title || content.children[i].text || ("Tab "+i);
    }
    if (content.children.length > 0) {
      content.children[currentIndex].visible = true;
      buttons.children[currentIndex].text = "<strong>" + buttons.children[currentIndex].text + "</strong";
    }
  }

  Component.onCompleted: tabview.currentIndex = 0;
  
}