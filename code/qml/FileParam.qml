import QtQuick.Controls 1.2

Rectangle {
/* Потоки данных
   - file, files - первичные входящие урль-имена файлов от внешних компонент

   далее FileSelect при filesChanged их меняет
   во втором таб-е можно кликнуть "Редактировать" и тогда..
 
*/
    id: param
    property var tag: "left"
    //    border.color: "grey"
    color: "transparent"
    radius: 2

    property var text //: title
    property var title
    property var min:0
    property var max:10
    property var step:1

    property alias value: param.file
    
    property var file
    property var files

    onFilesChanged: if (file != files[0]) file = files[0];
    
    property var showChosenFile: true

    property var guid: translit(text)

    onFileChanged: {
        if (file !== files[0]) {
            files = [file];
            //console.log("i reset fs.file to ",file );
            //fs.file = file;
        }
    }
    
    
    /*
    function setFile(file) {
      param.files = [file];
    }
    function setFiles(files) {
      param.files = files;
    }*/
    
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

    //property var color //:"red"

    //title: text
    
    width: 220
    //  height: param.multiple ? 65 : 90
    //height: 100
    height: col.implicitHeight+5

    Column {
        id: col
        Text {
            text: param.text
        }
        spacing: 5

        TabView {
            width: 180
            //height: param.multiple ? 60 : 43
            height: 43

            Tab {
                title: "Local"

                FileSelect {
                    id: fs
                    multiple: param.multiple
                    onFilesChanged: {
                        param.files = fs.files;
                    }
                    transparent: true
                }

            }

            Tab {
                title: "URL"
                anchors.fill: parent
                
                Row {

                    Button {
                      text: "Редактировать..."
                      onClicked: {
                        dialogFilesText.text = param.files && param.files.join ? param.files.join("\n") : param.file;
                        dlg.open();
                      }
                    }

                    
                    SimpleDialog {
                        id: dlg
                        title: param.text || "&nbsp;"
                        width: co.width + 30
                        height: co.height + 33
                        
                        Column {
                            id: co
                            width: 500
                            spacing: 8
                            y: 8
                            x: 10

                            Text {
                              text: "Укажите URL файлов, по одному в строке"
                            }
                            
                            TextEdit {
                                height: 300
                                width: parent.width
                                id: dialogFilesText
                            }

                            Button {
                                text: "Ввести адреса"
                                //width: parent.width
                                width: 150
                                onClicked: { 
                                  dlg.close(); 
                                  param.files = dialogFilesText.text.split("\n");
                                }
                            }
                        }

                        //onAfterOpen: dialogFilesText.text = txt.text;
                    }

                }

            }

        } //tabview

        Text {
            visible: param.showChosenFile
            // visible: !param.multiple
            text: {
                if (!param.file)
                    return "-";
                if (param.files.length > 1)
                    return "Выбрано файлов:" + param.files.length;
                if (param.file.name)
                    return "Выбран лок. файл: " + param.file.name;
                    
                var co = param.file.split("/");
                return "Выбран файл: <a target='_blank' href='" + param.file + "'>"+co[co.length-1]+"</a>\n\n"
            }
            //"Файл <a target='_blank' href='"+Qt.resolvedUrl(datafile)+"'>"+datafile+"</a>\n\n"
        }

    }

    ParamUrlHashing {
        name: globalName
        property: "files"
        enabled: !(param.file instanceof File)
        // записывать надо param.files но только если это не локальные файлы
    }

    property var globalName: scopeNameCalc.globalName
    ScopeCalculator {
        id: scopeNameCalc
        name: param.guid
    }

}
