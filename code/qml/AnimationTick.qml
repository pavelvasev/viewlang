Item {
  signal action();

  id: rt
  property var enabled: true

  function tick() {
    if (enabled) action();
  }

  Component.onCompleted: {
    var s = qmlEngine.rootObject; // @todo: animationManager...
    if (s && s.animationTick) s.animationTick.connect( rt, tick );
  }
  
  Component.onDestruction: {
    var s = qmlEngine.rootObject;
    if (s && s.animationTick) s.animationTick.disconnect( rt, tick );  
  }
  
}