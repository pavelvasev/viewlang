Item {
  id: osr
  /* Запуск
     запустить сервер D:\viewlang_sync\viewlanging\osc\udp-browser\run.cmd 
     запустить сцену
     включить галочку OSC
     запустить андроид приложение https://play.google.com/store/apps/details?id=com.charlieroberts.Control&feature=search_result
     прописать в нем адрес Host: 192.168.0.102, Port: 7400
     запустить интерфейс Акселерометр
  */

  property var target: parent

  property var  rotate: [(rx.value - c1) / c2, (ry.value - c1) / c2, (rz.value - c1) / c2]
  property var  scale: rs.value

  onRotateChanged: if (target) target.rotate = rotate;
  onScaleChanged: if (target) target.scale = scale;


  property var c1: 0
  property var c2: 180.0 / Math.PI

  property var lim: 90
  property var text: "необходим для ParamAnimation, етить"

  property alias rx: rx1
  property alias ry: ry1
  property alias rz: rz1
  property alias rs: rs1
  Param {
    id: rx1
    text: "rx"
    min: -lim
    max: lim
    value:0
  }

  Param {
    id: ry1
    text: "ry"
    min: -lim
    max: lim
    value:0
  }

  Param {
    id: rz1
    text: "rz"
    min: -lim
    max: lim
    value:0
  }

  Param {
    id: rs1
    text: "rscale"
    min: 0.1
    step: 0.1
    value: 1
    max: 10
  }

  function process() {
    var r = 10;
    osr.acc[0] = Math.ceil( osr.acc[0] / r) * r;
    osr.acc[1] = Math.ceil( osr.acc[1] / r) * r;
    osr.rx.value = -(osr.acc[0]-60);
    osr.rz.value = osr.acc[1]-60;

    // ry.value = acc[1];
    // rs.value = 10-(acc[2]-60)/6;
  }


  property var acc: [0,0,0]
  onAccChanged: process()

  ParamAnimation {
    name: "/accelerometer"
    property: "acc"
    target: parent
  }

}