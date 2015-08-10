CsvLoader {
  property var title: "Загрузка csv-файла"
  property var text: "Csv-файл данных"
  
  property var ctag: "left"
  property var cpriority: 0

  id: app
  file: fil.file

  Binding {
    target: fil
    property: "file"
    value: app.file
  }

  FileParam {
    id: fil
    text: app.text
    tag: ctag
    property var tag_priority: cpriority
  }

  Text {
    property var tag: ctag
    property var tag_priority: cpriority    
    text: "Загружено строк:"+app.output.length 
  }  

}