import QtQuick 2.3
import QtQuick.Controls 1.2

Rectangle {
    anchors.fill: parent
    color: "green"
    width:500
    height:500

    Rectangle {
        x: clickcount*10
        y:10
        width:100
        height:200
        color: "red"

        property int clickcount:0

        MouseArea {
            anchors.fill: parent
            onClicked: parent.clickcount++;
            cursorShape: Qt.PointingHandCursor
        }

        Text {
            anchors.horizontalCenter: parent.horizontalCenter
            y: 10
            text: "the x = " + parent.x + " and clickcount=" + parent.clickcount
        }

    }


}
