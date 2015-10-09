Item {
  signal action();

  id: rt
  property var enabled: true

  function tick() {
    if (enabled) action();
  }

  Component.onCompleted: {
    var s = findRootScene(rt);
    if (s) s.animationTick.connect( rt, tick );
  }
  
  Component.onDestruction: {
    var s = findRootScene(rt);
    if (s) s.animationTick.disconnect( rt, tick );  
  }
  
}