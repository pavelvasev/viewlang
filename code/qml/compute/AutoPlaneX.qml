PlaneX {
    opacity: 0.5
    id: planex
    positions: bounds.center && bounds.center.length > 0 ? [ bounds.center[0], bounds.center[1], -0.1] : []
    sizes: bounds.sizes && bounds.sizes.length > 0 ? [ bounds.sizes[0],bounds.sizes[1],0.1] : []

    property alias mult: bounds.mult

    ComputeBounds {
      id: bounds
      input: planex.source.positions
      mult: 1.05
    }

}