import QtQuick 2.3
import QtQuick.Controls 1.2

Rectangle {
    id: canvas
    color: "blue"

    Row {
      spacing: 5
      Text { 
        color: "white"
        text: "Current color="+canvas.color
      }

      Button { 
        text: "item 1"
        width: 100
        onClicked: canvas.color = "red"
      }
      Button { 
        text: "item 2"
        width: 100
        onClicked: canvas.color = "green"
      }
      Button { 
        text: "item 3"
        width: 100
        onClicked: canvas.color = "blue"
      }
    }

}