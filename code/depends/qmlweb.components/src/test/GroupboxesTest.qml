//import QtQuick 2.1
//import QtQuick.Controls 1.2
import qmlweb.components

Column {
    width: 500
    spacing: 5

    GroupBox {
        title: "GroupBox 1"
        width: parent.width
        id: gbox1

        Text {
            text: "This text is in groupbox. Groupbox.width is set to parent.width"
        }
        CheckBox {
            y: 20
            text: "This checkbox have y="+y
            onCheckedChanged: x=30
        }

    }

    GroupBox {
        title: "GroupBox 2"
        width: parent.width
        id: gbox2

        Column {
            spacing:3

            Button {
                width: 200
                text: "Click to change groupbox title"
                onClicked: gbox2.title = gbox2.title + " ;-)";
            }

            Text {
                text: "This groupbox have column inside. We check how GroupBox uses column height."
            }

        }//column

    }

    GroupBox {
        title: "GroupBox 3"
        id: gbox3

        Column {
            Text {
                text: "This groupbox have no width/height specified. Should compute it from children."
            }
            spacing: 3
            Rectangle {
                width: 50
                height: 50
                color: "green"
                id: r1
            }

            Row {
                Button {
                    text: "Grow rect"
                    width: 100
                    onClicked: { r1.height = 100; r1.width = 650; }
                }
                Text {
                    text: "after grow, the height of groupbox should change"
                }
            } // row
        }

    }

    GroupBoxF {
        title: "Direct fieldset. We need to implement padding."
        width: 400
        height: 150

        Column{
            x: 20
            y: 20
            Rectangle {
                width: 50
                height: 50
                color: "blue"
            }
            Rectangle {
                width: 350
                height: 50
                color: "green"
            }
        }
    }


}
