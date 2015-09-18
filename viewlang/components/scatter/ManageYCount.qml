Row {
    id: row
    property var target: parent
    property var tag: "right"

    Button {
      text: "Добавить"
      onClicked: row.target.ycount = row.target.ycount+1
    }
    Button {
      text: "Убрать"
      onClicked: if (row.target.ycount > 1) row.target.ycount = row.target.ycount-1
    }

    ParamUrlHashing {
      target: row.target
      property: "ycount"
      name: "scatter_ycount"
    }

}