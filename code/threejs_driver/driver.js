$driver = { colors: 3 };
// la_require_write("threex.domevents.js");

var threejs = {};

threejs.url = getCurrentScriptPath() + "/three.js-part/"

var scene = new THREE.Scene();

threejs.scene = scene;

//0 var camera = new THREE.PerspectiveCamera( 45, window.innerWidth / window.innerHeight, 0.1, 1000 );
var camera = new THREE.PerspectiveCamera( 45, window.innerWidth / window.innerHeight, 0.1, 1000*1000 );
//var camera = new THREE.OrthographicCamera( window.innerWidth / - 2, window.innerWidth / 2, window.innerHeight / 2, window.innerHeight / - 2, 1, 1000*10 );
threejs.camera = camera;
camera.position.z = 25;


///////////////////////////////////////// init

// https://threejs.org/docs/#api/en/renderers/WebGLRenderer.premultipliedAlpha
var renderer = new THREE.WebGLRenderer({
//  autoClear : false,
  alpha: true,
  preserveDrawingBuffer   : true   // required to support .toDataURL()
});


//var renderer = new SVGRenderer();
//var renderer = new THREE.SVGRenderer();
//document.body.appendChild( renderer.domElement );
//renderer.domElement.classList += "somethingLikeCanvas";

//var renderer = new THREE.CanvasRenderer();

threejs.renderer = renderer;

var selectedRenderer  = renderer;

renderer.setSize( window.innerWidth, window.innerHeight );
renderer.setClearColor( 0xB2B2CC, 1);
//renderer.autoClearColor = false;
//renderer.autoClearDepth = false;

document.body.appendChild( renderer.domElement );

var driverDomElement = renderer.domElement;
driverDomElement.classList.add("viewlang-canvas");

    // в js объекты не могут быть ключами, печалько
    // http://www.timdown.co.uk/jshashtable/
    // Поэтому objectsToRerender это массив из ячеек вида [объект,(таблица действий)]
    
var objectsToRerender = [];

function getObjDeeds( o ) {
      // меняем ключ на базовый объект. потому, что тот базовый объект тоже может вызывать makeLater, но уже с ключем-собой, 
      // и получится двойной вызов - один от наследного объекта, а второй от базового. Пример:
      // spheres.indices = x; -> повлечет makeLater(spheres);   spheres.material = y; -> повлечет makeLater(базовый объект)

      if (o && typeof(o.threeJsSceneObject) !== "undefined") {
        o = o.threeJsSceneObject;
      }

      for (var i=0; i<objectsToRerender.length; i++) 
        if (objectsToRerender[i][0] === o) {
          //console.log( "getObjDeeds found object, returning");
          return objectsToRerender[i];
        }

      objectsToRerender.push( [o,{}] );  
      return objectsToRerender[ objectsToRerender.length-1 ];
}

    function unmakeLater( o ) {
      if (o && typeof(o.threeJsSceneObject) !== "undefined") o = o.threeJsSceneObject;
      for (var i=0; i<objectsToRerender.length; i++) 
        if (objectsToRerender[i][0] === o) {
          //console.log("unmakeLater removed obj from queue, uniq=",o._uniqueId);
          objectsToRerender.splice(i,1);
          return;
        }
    }
    
    function makeLater( o,key,code )
    {
      if (!o.make3d) {
        console.error("you passed makeLater for object which doesn't have `make3d `method!");
        return;
      }

      var qq = objectsToRerender.length;
      var deeds = getObjDeeds( o );


      if (!key || !code) {
        // если не указан ключ - значит надо переделать все
        // и тоже самое если не указан код

        // очистка таблицы действий
        deeds[1] = {};
        // код на полную переработку
        code = function() { o.make3d(); }
        key = undefined;
      }

      
      // добавляем действие в таблицу. Но только если в ней нет действия на полную переработку. Если оно есть - другие действия уже не нужны
      if (!deeds[1][undefined]) 
        deeds[1][key] = code;
}
    
function doScheduledPrerenderTasks() {
      try {
      while (objectsToRerender.length > 0)
      {
          var record = objectsToRerender.splice(0,1) [0];
          var objs = record[0];
          //if (!objs.parent) return; // если объект уже удалили - в лес его дела
          
          var list_of_things_to_do = record[1];
          
          for (var make_key in list_of_things_to_do) 
          if (list_of_things_to_do.hasOwnProperty(make_key))
          {
            var deed = list_of_things_to_do[make_key];
            //console.log("calling deed=",deed);
            deed(); // это функция
          }
      }
      } finally {
      objectsToRerender = [];
      }
}

var clock = new THREE.Clock(true);    
var threejs_sceneTime = 0, threejs_sceneDelta = 0;

// aspect ctp
var render_aspect = function() {};
// event ctp (control transfer point)
var render_event = { type: 'render' }

function render() {
    threejs_sceneDelta = clock.getDelta();
    threejs_sceneTime = clock.elapsedTime;
    
    scene.dispatchEvent(render_event); // Sm RenderTick.qml
    
    doScheduledPrerenderTasks();
  
    //if (vrControl) vrControl.update();
    
    //sceneControl.update();
    
    render_aspect.apply();
  
    //debugger;
    selectedRenderer.render( scene, camera );
    ///renderer.render( scene, camera );
    // console.log("render called");
}

function animate() {
  renderer.setAnimationLoop( render );
}

animate();

function threeJsWindowResize() {
				camera.aspect = window.innerWidth / window.innerHeight;
				camera.updateProjectionMatrix();
				
				if (selectedRenderer.setSize)
  				  selectedRenderer.setSize( window.innerWidth, window.innerHeight );

  				if (selectedRenderer.setViewport) {
  				  selectedRenderer.setViewport(0, 0, window.innerWidth, window.innerHeight );
  				}
  				if (selectedRenderer.setScissor)
  				  selectedRenderer.setScissor(0, 0, window.innerWidth, window.innerHeight );
}

window.addEventListener( 'resize', threeJsWindowResize, false );


/// **********************************************

    // должна быть функция с таким именем
    function startScene()
    {
       // функция общего движка
       subtreeToScene( qmlEngine.rootObject );
       // из себя вызывает createSceneObject, которую тоже должен драйфер
    }
    
    // можно не переделывать, если такая же семантика, что весь код создания в make3d у объекта либо есть, либо нет
    function createSceneObject( qmlObject )
    {
      if (qmlObject.make3d)
      {
         unmakeLater( qmlObject );
         qmlObject.make3d();
         return true;
      }
      return false;
    }
    


var sceneMouse = new THREE.Vector2();
var raycaster = new THREE.Raycaster();

function onMouseMove( event ) {
	// calculate mouse position in normalized device coordinates
	// (-1 to +1) for both components

	sceneMouse.x = ( event.clientX / window.innerWidth ) * 2 - 1;
	sceneMouse.y = - ( event.clientY / window.innerHeight ) * 2 + 1;
}

function sceneDblClick( event ) {
//  console.log("ddd ",sceneMouse,event);
	// update the picking ray with the camera and mouse position	
	raycaster.setFromCamera( sceneMouse, camera );

	// calculate objects intersecting the picking ray
	var intersects = raycaster.intersectObjects( scene.children,true );
	console.log("intersects=",intersects);
	if (intersects.length == 0) return;
	
	var intersect = intersects[0];
	console.log(intersect.object, intersect.indices );
	/*
	for ( var i=0; i< intersects.length; i++ ) {
	  var intersect =intersects[i];
		intersect.object.material.color = new THREE.Color( 0xff0000 );
	}
	*/
}

renderer.domElement.addEventListener( 'mousemove', onMouseMove, false );    
// renderer.domElement.addEventListener( 'dblclick', sceneDblClick, false );
