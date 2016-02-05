Cylinders {
  id: cycy
  ratio: 0.7
  radius: 0.45

  Cones {
    ratio: cycy.ratio
    radius: cycy.radius * 2
    color: cycy.color
  }

}
