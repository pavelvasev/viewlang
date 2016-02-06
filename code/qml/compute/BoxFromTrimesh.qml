Boxes {
  id: boxes
  positions: bounds.center
  sizes: vMulScal( bounds.sizes, mult )
  colors: null
  property var mult: 1

  opacity: 0.5

  ComputeTrimeshBounds {
    source: boxes.source
    id: bounds
  }

}