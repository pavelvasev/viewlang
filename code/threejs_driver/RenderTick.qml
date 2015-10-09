import QtQuick 2.2

Item {
  signal action(real time, real delta);
  
  property bool enabled: true
  onEnabledChanged: chkEnabled();
  Component.onCompleted: chkEnabled();
    
  // todo переделать на handleEvent см https://developer.mozilla.org/ru/docs/Web/API/EventTarget/addEventListener

  property bool registered: false

  function chkEnabled() {
    if (enabled && !registered) {
      // то есть мы считаем что сцена есть..
      scene.addEventListener( 'render', function() { 
        if (enabled) 
          action(threejs_sceneTime, threejs_sceneDelta);
        
      });
      registered = true;
    }
  }

  // пока не реализовано Component.onDestruction
}    