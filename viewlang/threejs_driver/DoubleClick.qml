import QtQuick 2.2

Item {

  signal action(real time, real delta);

  Component.onCompleted: {
    scene.addEventListener( 'render', function() { 
      action(threejs_sceneTime, threejs_sceneDelta);
    });
  }

  // пока не реализовано Component.onDestruction
}    