$driver = { colors: 4 };

    // Point SceneJS to the bundled plugins
    SceneJS.setConfigs({
        pluginPath: "../scenejs/plugins"
    });
    
    // Create scene
    var scene = SceneJS.createScene();

    var driverDomElement = scene.canvas;
    
    // Add mouse-orbited camera, implemented by plugin at
    // http://scenejs.org/api/latest/plugins/node/cameras/orbit.js
    scene.addNode({
        type: "cameras/orbit",
        yaw: 30,
        pitch: -30,
        zoom: 7,
        zoomSensitivity: 1.0,
        
        nodes: [
              // We can't use #addNode to add nodes to a "cameras/orbit" node,
              // so we'll insert this container node that we can get by ID
              {
                  id: "content"
              }
        ]
    });
    
    var objectsToRerender = [];
    var sceneContent = null;

    scene.on("rendering", function() {
      if (!scene.mainContent) return;
      
      for (var i=0; i<objectsToRerender.length; i++)
        createSceneObject( objectsToRerender[i] );

      objectsToRerender.length = 0;
    } );
    
    function makeLater( o )
    {
      for (var i=0; i<objectsToRerender.length; i++)
        if (objectsToRerender[i] === o) return;
      objectsToRerender.push( o );  
    }

    ////////////////////////////////////////////////

    function startScene()
    {
      scene.getNode("content",
            function (content) {
              scene.mainContent = content;
              
              subtreeToScene( qmlEngine.rootObject );
              
//                content.addNode( { type: "effects/anaglyph" }, function(g) {
//                  console.log(114,g);
//                  qmlObjectToScene(qmlEngine.rootObject, g._leaf );
//                } );
            }
      ); // getnode
    
    }

    ////////////////////////////////////////////////

    function createSceneObject( qmlObject )
    {
      if (qmlObject.make3d)
      {
         qmlObject.make3d();
         return true;
      }
      return false;
    }

    ////////////////////////////////////////////////   
    