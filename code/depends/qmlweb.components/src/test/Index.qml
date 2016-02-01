import qmlweb.components

Rectangle {

  color: "lightgrey"
  
  property var sources: ["MainTest.qml","Combo.qml","GroupboxesTest.qml","DialogTest.qml","LoaderTest.qml","TabviewsTest.qml","BindingTest.qml","test_qmlweb_1.qml","test_qmlweb_2.qml","test_qmlweb_3.qml","CameraAndVideo.qml"]
  
  TabView {
    id: tabs
    anchors.fill: parent
    anchors.margins: 10

    Repeater {
      model: sources.length
      Tab {
        title: source.replace(".qml","")
        source: sources[index]
        Text {
          anchors.bottom: parent.bottom
          text: "open <a target='_blank' href='"+Qt.resolvedUrl(parent.source)+"'>"+parent.source+"</a>"
        }
      }
    }

  }

  ParamUrlHashing {
    target: tabs
    property: "currentIndex"
    name: "tabindex"
    timeout: 100
  }
}