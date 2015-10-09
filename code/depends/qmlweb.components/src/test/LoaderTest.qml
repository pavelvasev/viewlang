import qmlweb.components

Column {
    id: col
    property var r15: 15
    function foo() { return 16; }

    Row {
        height: 30
        Text {
            y:2
            text: "Choose file to load: "
        }
        
        ExclusiveGroup {
            id: ex
        }

        RadioButton {
            text: "A.qml"
            onCheckedChanged: if (checked) loader.source = text
            exclusiveGroup: ex
        }
        RadioButton {
            text: "B.qml"
            onCheckedChanged: if (checked) loader.source = text
            exclusiveGroup: ex
        }

        Text {
            y:2
            text: "Loader width: "
        }        
        Slider {
          minimumValue: 100
          maximumValue: 1000
          value: 500
          id: slider
        }

    }

    Loader {
        width: slider.value;
        height: 300
        id: loader

        onLoaded: loader.item.anchors.fill = loader

        Rectangle {
          anchors.fill:parent
          z:1
          border.color:"black"
          color:"transparent"
        }
    }

    /*
    Rectangle {
        width: 50
        height: 50
        color: "red"
    }
    Rectangle {
        width: 50
        height: 50
        color: "yellow"
    }
    */

}
