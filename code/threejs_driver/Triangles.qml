Trimesh {

  id: origin

  positions: source.positions
  colors: source.colors

  title: "Triangles"
  
  // вызывается make3d от trimesh-а. а он умеет работать без indices

  noIndices: true
  property var positionItemSize: 9
}