import QtQuick.Controls 1.2

GroupBox {
    id: param
    property var tag: "left"

    property var text //: title
    property var title
    property var value:min
    property var min:0
    property var max:10
    property var step:1

    property var file: fs.file
    property var files: fs.files

    property var multiple: false

    property var enableSliding: true

    property var values

    onValuesChanged: {
        min = 0;
        max = values.length -1;
        step = 1
        combo.model = values
    }

    signal changed(int newvalue, object event);

    //  onValueChanged: {
    //    slider.value = value;
    //    combo.currentIndex = Math.floor( (value - min) / step );
    //  }

    //spacing: 2
    //anchors.topMargin: 15

    property var color //:"red"

    //Text {
    //text: param.text
    //}
    title: text

    width: 220
    height: 90

    Column {
        spacing: 5

        TabView {
            width: 180
            height: param.multiple ? 60 : 43

            Tab {
                title: "Local"

                FileSelect {
                    id: fs
                    multiple: param.multiple
                    onFilesChanged: {
                        param.files = fs.files;
                        param.file = fs.file;
                    }
                }

            }

            Tab {
                title: "URL"
                anchors.fill: parent

                Button {
                    z: 5
                    anchors.right: parent.right+15+35
                    id: applyBtn
                    visible: false
                    text: "ДА"
                    onClicked: {
                        param.files = txt.text.split("\n");
                        param.file = files[0];
                        applyBtn.visible = false;
                    }
                }
                TextEdit {
                    id: txt
                    anchors.fill: parent
                    //width: parent.width
                    //height: 30
                    onTextChanged: {
                        applyBtn.visible = true
                    }
                }

            }

        } //tabview

        Text {
            visible: !param.multiple
            text: "Выбран файл: " + (param.file.name ? param.file.name : param.file )
        }

    }


}
