Cylinders {
  id: cycy
  ratio: 0.25

  Cones {
    ratio: 1 - cycy.ratio
    radius: cycy.radius * 2
  }
}
