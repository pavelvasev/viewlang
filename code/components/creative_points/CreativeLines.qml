Lines {
  id: obj

/*  потом
  Cylinders {
    id: cl
    radius: obj.radius
    visible
  }
  */
  
  property var ctag: "rightbottom"
  
  property alias text: ibtn.text
  Button {
      id: ibtn
      property var tag: ctag
      text: "Настройка отрезков.."
      width: 170
      onClicked: coco.visible = !coco.visible
  }

  Component.onCompleted: coco.visible = false;

  Column {
    property var tag: ctag
    id: coco

    Text {
      text: " "
      height: 10
    }
    /*
    Param {
      text: "вид"
      id: cvid
      value: 0
      values: ["линии","цилиндры"]
      tag: ctag
    }*/
  
    property alias radius_p: c2.value
    property alias radiusMax: c2.max
    Param {
      id: c2
      text: "radius"
      value: obj.radius
      max: 10
      tag: ctag
      step: 0.05
      onValueChanged: obj.radius=value
    }

    OpacityParam {
      target: obj
      tag:ctag
    }
  
    ColorParam {
     target: obj
     tag: ctag
    }
  }
  
}