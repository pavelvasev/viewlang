Item {
  // вообще спорно. а если мы хотим html менять? тогда надо OnHtmlChanged и перегенерировать.. непонятно в общем пока-что
  // аналогично кстати и js

  property var html
  property var js

  property var firstChild
  
  id: me

  Component.onCompleted: {
      if (js)
      {
        console.log("I eval");
        eval(js);
      }
  
      if (html) {
        me.dom.style.pointerEvents = "auto";
        me.dom.innerHTML = html;

        me.firstChild = me.dom.firstChild;
      }
  }
  
}