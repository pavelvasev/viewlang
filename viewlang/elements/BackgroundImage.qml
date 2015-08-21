// сделать отслеживание поворотов камеры и чуть чуть смещать картинку
Image {
    source: "http://img06.deviantart.net/a611/i/2005/335/5/b/abstract_nebula_by_daf_shadow.jpg"
    
    anchors.fill: findRootScene(imga) //parent
    z: -5
    id: imga

    property bool aspect: false
    property real mixOpacity: 0.1

    Component.onCompleted: {
        
      // надо перекинуть элемент из области qmlSpace, т.к. canvas живет вне ее, а нам надо чтобы наше z было меньше него.
      var element = jQuery(imga.dom).detach();
      jQuery('body').append(element);
      
      //renderer.setClearColor( 0xff0000, 0.1);
      aspectChanged();
      mixOpacityChanged();
    }
    
    onMixOpacityChanged: {
      //console.log("q");
      threejs.renderer.setClearColor( threejs.renderer.getClearColor(), mixOpacity);
    }

    onAspectChanged: {
      if (aspect)
        imga.dom.children[0].style.height = "";
      else
        imga.dom.children[0].style.height = "110%"; ///
    }
	  
}