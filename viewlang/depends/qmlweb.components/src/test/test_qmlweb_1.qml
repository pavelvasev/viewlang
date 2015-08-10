import QtQuick 2.3
import QtQuick.Controls 1.2

Rectangle {
    id: canvas
    width: 200
    height: 200
    color: "blue"

    Image {
        id: logo
        source: "http://data.lact.ru/f1/s/0/8/image/1650/963/medium_closed-bank-vault-20503256.jpg"
        x: canvas.height / 5
    }

    Text {
        id: message
        color: "white"
        text: "Hello World!"
        anchors.centerIn: parent
    }

    Button {
        x: 5
        y: 5
        text: "click me"
        onClicked: message.text = "hi!!!!"
    }

}
