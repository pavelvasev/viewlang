SceneObject {
  id: ars

  property var positions: source && source.positions?source.positions:[]
  property var colors: source && source.colors ?source.colors:[]
  property var nx: source && source.nx ? source.nx : 5
  property var radius: source && source.radius ? source && source.radius : 0.45

  property var positionItemSize: 6

  MakeStrip {
    input: ars.positions
    id: poss
  }

  MakeStrip {
    input: ars.colors
    id: colrs
  }

  Arrows {
    positions: poss.output
    color: ars.color
    colors: colrs.output
    opacity: ars.opacity
    radius: ars.radius
  }

}

