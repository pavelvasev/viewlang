SceneObject {
  id: ars

  property var positions: source && source.positions?source.positions:[]
  property var colors: source && source.colors ?source.colors:[]
  property var nx: source && source.nx ? source.nx : 5
  property var radius: source && source.radius ? source && source.radius: 1

  MakeStrip {
    input: ars.positions
    id: poss
  }

  Arrows {
    positions: poss.output
    color: ars.color
  }

}

