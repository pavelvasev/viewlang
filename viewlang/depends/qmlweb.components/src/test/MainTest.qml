//import QtQuick.Controls 1.2
import qmlweb.components

Item {
    width: 500
    height: 500

    Column {
        x:5
        y:5
        width: parent.width
        spacing: 5

        GroupBox { 
          title: "RadioButton test"
          id: radiogroup

          Row {
            ExclusiveGroup { id: tabPositionGroup }
            RadioButton {
              text: "First choice"
              exclusiveGroup: tabPositionGroup
              onCheckedChanged: if (checked) radiogroup.title = "you select "+text
            }
            RadioButton {
              text: "The long Second choice"
              exclusiveGroup: tabPositionGroup
              onCheckedChanged: if (checked) radiogroup.title = "you select "+text              
            }
            RadioButton {
              text: "Third choice"
              exclusiveGroup: tabPositionGroup
              onCheckedChanged: if (checked) radiogroup.title = "you select "+text              
            }            
          }
        }

        GroupBox {
            title: "GroupBox test"
            width: parent.width*0.8
            id: gbox

            Column {
                spacing:3

                Button {
                    width: 200
                    text: "Click to change groupbox title"
                    onClicked: gbox.title = gbox.title + " 1";
                }

                Text {
                    text: "Some text. We check how GroupBox uses column height."
                }
            }//column

        }


        GroupBox {
            title: "FileSelect test"

            FileSelect {
                id: fs
                onFileChanged: console.log("selected file=",file.name);
            }
        }

        GroupBox {
            title: "Buttons test"
            Row {
                spacing: 3

                Button {
                    id: btn
                    text: "some text"
                    onClicked: btn.text = "12345"
                }

                Button {
                    id: btn2
                    text: "some text 2"
                    onClicked: btn2.text = "12345!"
                }
            } // row
        } // groupbox buttontest


        GroupBox {
            title: "Checkbox test"
            /*
            Rectangle {
                width: 120
                height: 30
                color: "red"
            }*/
            CheckBox {
                text: "Click me.."
                width: 200
                onCheckedChanged: text = "thank you! checked="+checked;
            }
        }

        GroupBox {
            title: "Slider test"

            Row {
                spacing:10
                Slider {
                    id: sla
                    value: 0.3
                }
                Text {
                    text: "value ="+sla.value
                }
            } // row for slider
    } // groupbox

    Text {
      text: "progress bars, one with value and second indeterminate:"
    }

    ProgressBar {
      value: sla.value
      maximumValue: 1
    }
    ProgressBar {
      indeterminate: true
    }    
    
}
}
