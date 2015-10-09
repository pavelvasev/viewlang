// Importing was not supported while writing this example
//import QtQuick 1.0
Rectangle {
    id: main
    width: 600; height: 400
    color: "lightgray"
    function getSize() {
        return width + "x" + height
    }
    Text {
        id: text1
        text: "Rectangle size is "
            + main.getSize()
        font.pointSize: 32
        y: main.height / 3
        anchors.horizontalCenter:
            main.horizontalCenter
    }
    Text {
        text: "Rectangle id is \""
            + __executionContext.nameForObject(main) + '"'
        font.pointSize: 16
        anchors.top:
            text1.bottom
        anchors.horizontalCenter:
            main.horizontalCenter
    }
}

