import QtQuick.Controls 1.2

Rectangle {
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
    
    property var file: fs.file
    property var files: fs.files
    
    property var showChosenFile: true

    property var guid: translit(text)

    onFileChanged: {
      if (fs.file !== file) {
        //console.log("i reset fs.file to ",file );
        //fs.file = file;
      }
    }

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
                        param.file = fs.file;
                    }
                    transparent: true
                }

            }

            Tab {
                title: "URL"
                anchors.fill: parent
                
                Row {

                Button {
                    z: 5
                    //anchors.right: parent.right+15+35
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
                    //anchors.fill: parent
                    //width: parent.width
                    width: 190
                    height: 20
                    text: { 
                      var t = "";
                      if (param.files.length > 0) {
                        for (var i=0; i<param.files.length; i++)
                          if (!param.files[i].name)
                            t = t + param.files[i] + "\n";
                        return t;
                      }
                      return param.file;
                    }
                    //z: 5100
                    onTextChanged: {
                        if (text != param.file)
                        applyBtn.visible = true
                    }
                 }

                }

            }

        } //tabview

        Text {
          visible: param.showChosenFile
//            visible: !param.multiple
            text: {
              if (!param.file)
                return "";
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
