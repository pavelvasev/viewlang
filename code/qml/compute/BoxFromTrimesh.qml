Boxes {
  id: boxes
  positions: bounds.center
  sizes: vMulScal( bounds.sizes, mult )
  colors: null
  property var mult: 1

  opacity: 0.5

  ComputeBounds {
    source: boxes.source
    id: bounds
    enabled: boxes.source != boxes && boxes.source != boxes.trimesh
  }

}