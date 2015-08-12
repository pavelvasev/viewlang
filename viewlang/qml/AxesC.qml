Axes {
   id: ax
   r: param.value
   dashed: r > 10 //true
                 
   Param {
      visible: ax.visible
      id: param
      value: 50
      //text: "Размер оси"
      text:""
      guid: "axes_size"
      property var tag: "bottom"      
      height: 20
    }
}
