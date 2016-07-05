Axes {
   id: ax
   r: param.value
   dashed: r > 10 //true

   //property alias radius: ax.r
   property var aparam: param

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
