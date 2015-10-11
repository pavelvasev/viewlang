import qmlweb.components

Item {
    width: 500
    height: 400
    
    SimpleDialog {
        id: dlg
        title: "This Dialog title"
        height: co.height + 30
        
        Column {
            id: co
            width: 300
            spacing: 3

            Text {
                text: "i am a text inside column inside dialog"
            }

            Repeater {
                model:3
                Button {
                    width: 250
                    text: "i am repeated button inside dialog"
                }
            }

            TextEdit {
              height: 100
              width: parent.width
              id: dlgte1
            }

            Button {
              text: "Click me to save!"
              width: parent.width
              onClicked: { dlg.close(); textarea1.text = dlgte1.text; }
            }
        }

        onAfterOpen: dlgte1.text = textarea1.text;
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
        
        TextEdit {
          id: textarea1
          text: "some textarea value.. click to edit.. When you will click, it will open editing dialog."
          height: 200
          onFocused: {
            dlg.open();
          }
        }

        TextField {
          id: textfield1
          text: "some textfiel value.. click to edit.."
          onFocused: {
            dlg.open();
          }
        }        
    }
}
