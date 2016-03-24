Lines {
    id: lin

    property var r: 50
    dashed: true

    positions: [-r,0,0, r,0,0,
                 0,-r,0, 0,r,0,
                 0,0,-r, 0,0,r ]

    ///color:[1,1,1] 
    colors: [1,0,0, 1,0,0,
             0,1,0, 0,1,0,
             0,0,1, 0,0,1 ]             

    Points {
      visible: lin.visible
      positions: [ r,0,0, 0,r,0,  0,0,r ]
      colors: [1,0,0, 0,1,0, 0,0,1]
      radius: 1
    }

  property var titles: ["X","Y","Z"]

  property var titleScale: r / 5
  TextSprite { 
    center: [ r,0,0 ]
    text: titles[0]
    pixelSize: 40
    radius: titleScale
    italic: true
    bold: true
    centered: true
    visible: lin.visible
  }

  TextSprite { 
    center: [ 0,r,0 ]
    text: titles[1]
    pixelSize: 40
    radius: titleScale
    italic: true
    bold: true
    centered: true
    visible: lin.visible
  }

  TextSprite { 
    center: [ 0,0,r ]
    text: titles[2]
    pixelSize: 40
    radius: titleScale
    italic: true
    bold: true
    centered: true
    visible: lin.visible
  }

}
