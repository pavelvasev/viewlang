Points {
  id: pts
  property var ctag: "rightbottom"
  radius: 20
  
  //radius: c2.value
  textureUrl: ctex.values[ctex.value] ? Qt.resolvedUrl("sprites/"+ctex.values[ctex.value]) : null
  alphaTest: c3.value / 100
  additive: c4.value>0
  depthWrite: c5.value>0
  depthTest: c6.value>0
  color: [1,0,0]
  //property alias tex: ctex

  Param {
    text: "<b>Points params</b>\ntexture"
    id: ctex
    value: 1
    values: ["spark1.png","ball.png","circle.png","disc.png","particle.png","particleA.png",""]
    tag: ctag
  }
  
  property alias radiusMax: c2.max
  Param {
    id: c2
    text: "radius"
    value: pts.radius
    max: 10
    tag: ctag
    step: 0.05
    onValueChanged: pts.radius=value
  }

  Param {
    id: c3
    text: "alpha test"
    value: 50
    max: 99
    tag: ctag
  }  
  
  Param {
    id: c4
    text: "additive"
    value: 0
    max: 1
    tag: ctag
  }

  Param {
    id: c5
    text: "depth write"
    value: 1
    max: 1
    tag: ctag
  }  

  Param {
    id: c6
    text: "depth test"
    value: 1
    max: 1
    tag: ctag
  }

  OpacityParam {
   tag:ctag
  }

  ColorParam {
   tag: ctag
  }

}