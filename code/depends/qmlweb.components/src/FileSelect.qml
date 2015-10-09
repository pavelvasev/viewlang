Embed {
  height: 21
  width: 200
  property var transparent: false

  html: "<input type='file' " + (multiple ? "multiple" : "") + " style='width:" + width + "px;" + (transparent ? "color: transparent;":"") + "'/>" 
  id: me

  property var file
  property var files
  property var multiple: false
 
  // if user set file property from outside, change input look.
  onFileChanged: {
    var d =  this.dom.children [0];
    if (d && d.files && d.files[0] !== file) {
      if (file.name)
        jQuery( this.dom.children [0] ).val(file);
      else
        jQuery( this.dom.children [0] ).val("");
      /*
      d.files[0] = file;
      */
    }
  }

  // signal data();

  Component.onCompleted: {
    me.firstChild.addEventListener('change', handleFileSelect, false);
  }

  // http://www.html5rocks.com/en/tutorials/file/dndfiles/
  function handleFileSelect(evt) {
    var htmlFiles = evt.target.files; // FileList object
    file = htmlFiles[0];
    files = htmlFiles;
    
    // ридеры в другом месте должны быть.. 
    // var reader = new FileReader();
  }

}