import QtQuick 2.2

Item {
  signal action(real time, real delta);
  
  property bool enabled: true
  onEnabledChanged: chkEnabled();
  Component.onCompleted: chkEnabled();
    
  // todo ���������� �� handleEvent �� https://developer.mozilla.org/ru/docs/Web/API/EventTarget/addEventListener

  property bool registered: false

  function chkEnabled() {
    if (enabled && !registered) {
      // �� ���� �� ������� ��� ����� ����..
      scene.addEventListener( 'render', function() { 
        if (enabled) 
          action(threejs_sceneTime, threejs_sceneDelta);
        
      });
      registered = true;
    }
  }

  // ���� �� ����������� Component.onDestruction
}    