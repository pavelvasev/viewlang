Lines {
  id: arr
  property var type: "Lines"

  positions: comb.output
  colors: []
  radius: 0.01

  ComputeTrimeshCenters {
      source: arr.source
      id: centras
  }

  ComputeTrimeshNormals {
      source: arr.source
      id: norms
  }

  MakeCombineAdd {
      input1: centras.output
      input2: norms.output
      id: comb
  }
}
