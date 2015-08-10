import qmlweb.components

Row {
  spacing: 10

  Text {
    y: 3
    text: "Enter data here"
  }

  TextField {
    id: t1 
    width: 150
  }

  Text {
    y: 3
    text: "value bound here"
  }

  TextField {
    id: t2
    width: 150    
  }  

  Binding {
    target: t2
    property: "text"
    value: t1.text
  }

  Text {
    y: 3
    id: txt
    text: "value bound here"
  }
    
  Binding {
    target: txt
    property: "text"
    value: "second text length = " + (t2.text || "").length
  }

}