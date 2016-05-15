Boxes {
  id: boxes
  positions: bounds.center
  sizes: vAdd( vMulScal( bounds.sizes, mult ), add )
  colors: null
  property var mult: 1
  property var add: [0,0,0]

  opacity: 0.5

  ComputeBounds {
    source: boxes.source
    id: bounds
    enabled: boxes.source != boxes && boxes.source != boxes.trimesh
  }

}