import "."

Button {
     property var target: parent

     text: "Масштаб 1:1"
     width: 100
     z:1
     
     onClicked: {
       target.reset();
     }
     property var tag: target.controlsTag
}
