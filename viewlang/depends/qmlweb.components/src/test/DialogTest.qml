import qmlweb.components

Item {
    width: 500
    height: 400

    SimpleDialog {
        id: dlg
        title: "Dialog title"
        Column {
            width: 300
            Text {
                text: "i am a text"
            }

            Repeater {
                model:5
                Button {
                    width: 200
                    text: "i am button inside dialog"
                }
            }
        }
    }

    Row {
        spacing:5

        Button {
            text: "dlg.open()"
            onClicked: dlg.open();
        }

        Button {
            text: "dlg.close()"
            onClicked: dlg.close();
        }
    }
}
