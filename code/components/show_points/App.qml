import components.creative_points 1.0

SceneObject {
  id: app
  property var ctag: "left"

  property var text: "Точко-сферы"

  property var positions

  property var colors
  property var radius: prParam.value /// mode == 0 ? prParam.value / 10 : prParam.value / 10
  property var radiuses: []
 
  property var nx: 8
  property var ny: 8
  property var wire

  property var shader

  property alias radiusParam: prParam

  visible: radius > 0 && opacity > 0

  //property int mode: 0
  property alias mode: modeParam.value

  function intersect( coords )
  {
    if (!loader.item) return false;
    return loader.item.intersect( coords );
  }

  Loader {
    source: ["Points","CreativePoints","Spheres"] [mode]
    id: loader
    onLoaded: {
      console.log("mode=",mode,"source=",source);
      item.source = app;
      //item.make3d();
    }
    ///onItemChanged: console.log("*********** item changed",item);
    onItemChanged: engine.rootObject.refineAll();
  }
  property var painter: loader.item


  Param {
    values: ["точки","красивые точки","сферы"]
    id: modeParam
    text: app.text + " / Тип отображения"
    tag: ctag
    //sliderEnabled: false
    valEnabled: false
  }
  
  Param {
    text: app.text + " / Размер"
    id: prParam
    value: 1
    step: 0.1
    min: 0
    max: 7
    enableSliding: mode==0
    tag: ctag
  }  

  OpacityParam {
    target: loader.item
    tag: ctag
  }
  

  Binding {
    target: loader.item
    property: "radius"
    value: app.radius
  }
  
  Binding {
    target: loader.item
    property: "radiuses"
    value: app.radiuses
  } 
  
  Binding {
    target: loader.item
    property: "colors"
    value: app.colors
  }   

  Binding {
    target: loader.item
    property: "color"
    value: app.color
  }     

  Binding {
    target: loader.item
    property: "nx"
    value: app.nx
  }

  Binding {
    target: loader.item
    property: "ny"
    value: app.ny
  }

  Binding {
    target: loader.item
    property: "center"
    value: app.center
  }  

  Binding {
    target: loader.item
    property: "wire"
    value: app.wire
  }    

  Binding {
    target: loader.item
    property: "visible"
    value: app.visible
  }

  Binding {
    target: loader.item
    property: "shader"
    value: app.shader
  }  

}