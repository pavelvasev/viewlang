Trimesh {
  id: obj
  
  property var ctag: "rightbottom"
  
  property var scopeName: "mesh"
  
  materials: [ [m1,m2,m3][pMat.value] ]
  
  property alias text: ibtn.text
  property alias flat: pShading.value
  property alias shine: pShine.value
  
  PhongMaterial {
      id: m1
      shine: pShine.value
      flat: pShading.value >0
      wire: pWire.value>0
      wirewidth: pWire.value
//      emissive: 0xffff00
//      color: 0xff0000
//      specular:0xff0000
  }

    MetalMaterial {
      id: m2
      metalness: pShine.value / 100.0

      wire: pWire.value>0
      wirewidth: pWire.value
      flat: pShading.value >0      
//      emissive: 0xffff00
//      color: 0xff0000
//      specular:0xff0000
    }
    
   // https://threejs.org/docs/#api/en/materials/MeshLambertMaterial
    LambertMaterial {
      id: m3

      wire: pWire.value>0
      wirewidth: pWire.value
      flat: pShading.value >0
//      emissive: 0xffff00
//      color: 0xff0000
//      specular:0xff0000
    }

  Button {
      id: ibtn
      property var tag: ctag
      text: "Настройка поверхности.."
      width: 170
      onClicked: coco.visible = !coco.visible
  }

  Component.onCompleted: coco.visible = false;

  Column {
    property var tag: ctag
    id: coco

    Text {
      text: " "
      height: 10
    }
    
    Param {
      text: "Материал"
      id: pMat
      value: 0
      values: ["Фонг", "Металл","Ламберт"]
      tag: ctag
      guid: "material"
    }
    
    Param {
      text: "Раскраска △▲"
      id: pShading
      guid: "shading"
      value: 0
      values: ["Гладкое","Плоское"]
      tag: ctag
      onValueChanged: {
        if (value == 0) 
          setTimeout( function() { obj.make3d() },5); 
          // for compute normals
          // timetout is for passing values to material
        }
    }    
    
    Param {
      id: pShine
      title: "Яркость / металличность"; min: 0; max: 100; value: 30
      guid: "shine"
    }
    
    Param {
      id: pWire
      title: "Только каркас"; min: 0; max: 10; value: 0; step: 0.1
      guid: "wire"
    }

    OpacityParam {
      target: obj
      tag: ctag
    }
  
    ColorParam {
      target: obj
      tag: ctag
    }
    
  }
  
}