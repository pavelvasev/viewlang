// По объекту source и вариантам titles дает параметр выбора 1 элемента, 
// после чего создает объект как source для отображения выбранного элемента

SceneObject {
  id: so
  property var titles: []
  property var text: "Выбор"
  title: text
  visual: false

  property var positions: source && source.positions ? source.positions : []
  property var indices: source && source.indices ? source.indices : null
  property var radiuses: source && source.radiuses ? source.radiuses : null
  property var radius: source && source.radius ? source.radius : null

  color: [1,0,0]

  property var itemSize: source && source.positionItemSize ? source.positionItemSize : 3
  property var itemShiftSize: source && source.$class && source.$class.toLowerCase().indexOf("strip") > 0 ? itemSize / 2 : itemSize;

  //property var positionItemSiftSize: source && source.positionItemSiftSize ? source.positionItemSiftSize : itemSize
  //property var itemSize: source && source.positionItemSize ? source.positionItemSize : 3
  //property var itemSize: source && source.$class && source.$class
  //property var itemShiftSize: source && source.$class && source.$class.downcase().indexOf("strip") > 0 ? itemSize / 2 : itemSize;

  property var itemsCount: Math.floor( positions.length / itemShiftSize )

  property var forceType

  property var param: selectedItem
  Param {
    text: so.text
    values: so.titles.length > 0 ? ["-1"].concat( so.titles ): []
    //values: so.titles.length > 0 ? so.titles : []
    id: selectedItem
    min: -1
    max: so.itemsCount-1
  }
/*
  Text { 
    property var tag: "left"
    text: selectedItem.value
  }
*/

  MakeExtract {
    input: so.positions
    count: so.itemSize
    offset: (selectedItem.value-0) * so.itemShiftSize
    id: extr
  }

  property var repl: {
    return { "Points" : "Spheres", "Linestrip" : "Cylinderstrip", "Lines" : "Cylinders" };
    //в связи с superviewlang это неправильно стало.
    // норм, там же PointsRobot а не Points
    //return {};
  }

  Loader {
    id: loader
    source: so.source ? (so.forceType || repl[ so.source.$class ] || so.source.$class): null
    //onSourceChanged: console.log("loading source=",source);
    onLoaded: item.$class = so.forceType || repl[ so.source.$class ] || so.source.$class;
  }

  Binding {
    target: loader.item
    property: "title"
    //value: so.source.title + " - Выбранный объект"
    value: "Выбранный объект "+so.source.$class
    when: so.source && so.source.title
  }

  /*
  Binding {
    target: loader.item
    property: "robotIcon"
    value: "fa-hand-rock-o"
  }*/

  Binding {
    target: loader.item
    property: "positions"
    value: extr.output
  }

  Binding {
    target: loader.item
    property: "radius"
    value: so.radius * 1.2
    when: so.radius > 0
  }

  Binding {
    target: loader.item
    property: "color"
    value: so.color
  }

/*
  property var showerItem: null

  onSourceChanged: {
    console.log( "source=",source.$class );
    Qt.createComponent( "source.$class" );
  }
*/
}