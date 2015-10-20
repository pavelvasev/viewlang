//import QtQuick 2.3
//import QtQuick.Controls 1.2

Item {
  height: 20
  // compute with based on content
  // but we have to used not currentText, but some average or max options text len
  //width: currentText ? currentText.length * 20 : 100
  width: 80

  property var htmlTagName: "select"

  id: self

  property var model: ['value1','value2','value3', 'value4']

  property int    currentIndex: 0
  property string currentText:  model[currentIndex]
  property int    count: 0 //model.length
  property int    size: 1 

  Component.onCompleted: {
    init(true);
  }

  onSizeChanged: {
    var item = self.dom;//.firstChild;
    if (item)  {
      //console.log("combobox: assign size =",size,item);
      item.size = size;
    }
    else {
      //console.log("combobox: size cannot be set");
    }
  }
  
  function handleSelectItem(e){
    var index = parseInt(e.target?e.target.value:currentIndex);
    currentIndex = index;
  }

  // sometimes we do not want to force the change currentIndex if it more than count
  property bool checkCurrentIndex: true

  function init(installHandler) {
    self.dom.style.pointerEvents = "auto";
    //self.dom.innerHTML = ''; // TODO optimize
    
    count = model.length;
    if (checkCurrentIndex)
      currentIndex = (currentIndex >= count) ? count-1 : currentIndex;


    /*
    for(var i = 0; i < k; i++) {
      str += '<option value="'+i+'" '+(i==currentIndex?'selected':'')+'> '+model[i]+'</option>';
    }
    self.dom.innerHTML = str;
    */

    // http://www.tigir.com/javascript_select.htm
    // var newOpt = new Option("text", "value", isDefaultSelected, isSelected);
    
    var item = self.dom; //.firstChild;
    var k = count;

    item.options.length = k;
    for(var i = 0; i < k; i++) {
      var isselected = (i==currentIndex);
      item.options[i] = new Option(model[i], i, isselected,isselected); // i==currentIndex second time?
    }    
    
    
    item.style.width = width + 'px';
   
    if (installHandler)
        item.addEventListener('change', handleSelectItem, false);
  }

  onCurrentIndexChanged: {
    var item = self.dom; //.firstChild;
    //debugger;
    if (item && currentIndex <= count) {
        //currentText = model[currentIndex]
        //debugger;
        if (item.children[currentIndex])
          item.children[currentIndex].selected = true;
      }
  }

  onModelChanged: {
    init(false);
  }
}

