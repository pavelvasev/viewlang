Row {
  id: links
  spacing: 5

  property var tag: "base"

  property var values: []
  property var text: ""
  
  /*
  Text {
    text: links.text + ":"
  }

  Repeater {
    model: values.length
    Text {
      text: "<a target='_blank' href=\"" + values[index][1] + "\">"+values[index][0]+"</a>"
    }
  }
  */
  
  Text {
    y: 3
    text: { 
      var res = links.text + ": ";
      for (var i=0; i<values.length; i++) {
        var link = values[i];
        var a = "<a target='_blank' href=\"" + link[1] + "\">"+link[0]+"</a>";
        res = res + (i > 0 ? " | " : "") + a;
      }
      return res;
    }
  }  
 
}