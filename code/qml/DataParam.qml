import QtQuick.Controls 1.2

// Вход:
// Выход:
// file, files
// - типа FileObject
// - строка - тогда это URL
// - или объект { plainData: xxx } - тогда это прямо вот данные

Rectangle {
    /* Потоки данных
   - file, files - первичные входящие урль-имена файлов от внешних компонент

   далее FileSelect при filesChanged их меняет
   во втором таб-е можно кликнуть "Редактировать" и тогда..

*/
    property var dataDialog: dlg2

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
    //property var showChosenFile: true

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
        files = values;
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
    
    width: 250
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
            width: 220
            //height: param.multiple ? 60 : 43
            height: 43
            id: tabview

            Tab {
                title: "Файл"

                FileSelect {
                    id: fs
                    multiple: param.multiple
                    onFilesChanged: {
                        param.files = fs.files;
                    }
                    transparent: true
                }

            }
            ///////////////////////////////////////////////////////////////////
            Tab {
                title: "Адрес"
                anchors.fill: parent
                
                Row {

                    Button {
                        width: 120
                        text: "Редактировать.."
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
                        z: 5002
                        
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

            ///////////////////////////////////////////////////////////////////
            Tab {
                title: "Данные"
                anchors.fill: parent

                Row {

                    Button {
                        width: 120
                        text: "Редактировать..."
                        
                        onClicked: dlg2.prepare_and_open();
                    }


                    SimpleDialog {
                        id: dlg2
                        title: param.text || "&nbsp;"
                        width: co.width + 30
                        height: co.height + 33
                        z: 5002

                        property bool dataloading: false
                        function prepare_and_open() {
                            //loader1.file = param.file;
                            if (!dataloading) {
                                dialogFilesText2.text = "Загружаю..."

                                dataloading = true;
                                loadFile( param.file, function(res) {
                                    dialogFilesText2.text = res;
                                    dataloading = false;
                                }, function (err) {
                                    dialogFilesText2.text = "Ошибка загрузки"
                                    dataloading = false;
                                } );
                            }

                            dlg2.open();
                        }

                        Column {
                            id: co
                            width: 500
                            spacing: 8
                            y: 8
                            x: 10

                            Text {
                                text: "Данные"
                            }

                            /*
                            TextLoader {
                                //enabled: false
                                id: loader1
                                onLoaded: dialogFilesText2.text = output
                            }*/

                            TextEdit {
                                height: 300
                                width: parent.width
                                id: dialogFilesText2
                            }

                            Button {
                                text: "ВВОД"
                                //width: parent.width
                                width: 150
                                onClicked: {
                                    dlg2.close();
                                    var onefile = { content: dialogFilesText2.text }
                                    param.files = [onefile];
                                }
                            }
                        }
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

                if (param.file.split) {
                    var co = param.file.split("/");
                    return "Выбран файл: <a target='_blank' href='" + param.file + "'>"+co[co.length-1]+"</a>\n\n"
                }

                return "Введены данные";
            }
            //"Файл <a target='_blank' href='"+Qt.resolvedUrl(datafile)+"'>"+datafile+"</a>\n\n"
        }

    }

    ParamUrlHashing {
        name: globalName
        property: "files"
        enabled: !(param.file instanceof File) && (param.file && param.file.content ? (param.file.content.length && param.file.content.length < 12048) : true)
        //enabled: !(param.file instanceof File) && !(param.file && param.file.content)
        // записывать надо param.files но только если это не локальные файлы
        id: hasher
    }
    

    property var globalName: scopeNameCalc.globalName
    ScopeCalculator {
        id: scopeNameCalc
        name: param.guid
    }
    
    property alias ahasher: hasher
    property alias atabview: tabview

}
