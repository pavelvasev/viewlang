Rectangle {
    color: "transparent"
    id: err

    property alias line1: aline1.text
    property alias line2: aline2.text
    property alias info : aline2.text

    Rectangle {
        anchors.fill: parent
        anchors.margins: 10

        color: "black"
        Column {
            x: 5
            y: 5
            spacing: 10
            Text {
                id: aline1
                text: "Your file caused error. Use browser console to see details.\n(ctrl+shift+j in chrome)"
                color: "red"
            }
            Text {
                id: aline2
                color: "cyan"
            }
        }

    }
}
