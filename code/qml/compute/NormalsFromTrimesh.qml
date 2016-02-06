Arrows {
  id: arr

  positions: comb.output
  colors: []
  radius: 0.01

  ComputeTrimeshCenters {
      source: arr.source
         /*
      Spheres {
        positions: parent.output
        radius: boxes.radius / 10
      }*/
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