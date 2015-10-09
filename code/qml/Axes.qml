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
}
