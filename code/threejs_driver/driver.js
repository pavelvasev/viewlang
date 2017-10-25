$driver = { colors: 3 };
// la_require_write("threex.domevents.js");

var threejs = {};

var scene = new THREE.Scene();

threejs.scene = scene;

//0 var camera = new THREE.PerspectiveCamera( 45, window.innerWidth / window.innerHeight, 0.1, 1000 );
var camera = new THREE.PerspectiveCamera( 45, window.innerWidth / window.innerHeight, 0.1, 1000*10 );
//var camera = new THREE.OrthographicCamera( window.innerWidth / - 2, window.innerWidth / 2, window.innerHeight / 2, window.innerHeight / - 2, 1, 1000*10 );
threejs.camera = camera;

camera.position.z = 25;

//var light0 = new THREE.AmbientLight( 0x444444 );
////var light0 = new THREE.AmbientLight( 0x004000 );
//				scene.add( light0 );
				
				/*
				var light1 = new THREE.DirectionalLight( 0xffffff, 0.5 );
				var r = 50;
				light1.position.set( r, r, r );
				scene.add( light1 );

				var light2 = new THREE.DirectionalLight( 0xffffff, 1.5 );
				light2.position.set( 0, -r, 0 );
				scene.add( light2 );
				*/
/*	
				var spotLight = new THREE.SpotLight( 0xffffff );
         spotLight.position.set( 100, 100, 100 );
         scene.add( spotLight );
         
         
				var spotLight2 = new THREE.SpotLight( 0xffffff );
         spotLight2.position.set( -200, -300, -300 );
         scene.add( spotLight2 );
*/

/*
var light = new THREE.PointLight( 0xffffff, 1 );
light.position.set( 50, 50, 50 );
scene.add( light );

var sphereSize = 1;
var pointLightHelper = new THREE.PointLightHelper( light, sphereSize );
scene.add( pointLightHelper );

var light = new THREE.PointLight( 0xffffff, 1 );
light.position.set( -50,-50, -50 );
scene.add( light );
*/
/*
var sphere = new THREE.SphereGeometry( 0.5, 16, 8 );
light.add( new THREE.Mesh( sphere, new THREE.MeshBasicMaterial( { color: light.color.getHex() } ) ) );
*/


//var sphereSize = 1;
//var pointLightHelper = new THREE.PointLightHelper( light, sphereSize );
//scene.add( pointLightHelper );

/*
la_require("../threejs/examples/js/controls/TrackballControls.js", function() {
  var controls = new THREE.TrackballControls( camera );
  controls.addEventListener( 'change', render );
} );  
*/


/*
var controlType = "OrbitControls";
var sceneControl;
var sceneCenterPoint =  new THREE.Vector3();

la_require("three.js/examples/js/controls/"+controlType+".js", function() {
  var cls = eval("THREE."+controlType);

  var controls = new cls( camera, renderer.domElement );
  //controls.autoRotate = true;

  // установим, а то вдруг в qml ее уже выставили
  controls.target = sceneCenterPoint; //new THREE.Vector3( 13,18,100 );
  console.log( "Mouse control created, controls.target=", controls.target );

  controls.update();
  sceneControl = controls;

  //controls.addEventListener( 'change', render );
} );
*/

/////////////////////////////////////////

var vrDisplay, vrControl;

/////////////////////////////////////////

//var container = document.getElementById("canvas-1");

//var renderer = new THREE.WebGLRenderer( { canvas: container  } );
var renderer = new THREE.WebGLRenderer({
  alpha: true,
  preserveDrawingBuffer   : true   // required to support .toDataURL()
});
threejs.renderer = renderer;

var selectedRenderer  = renderer;

renderer.setSize( window.innerWidth, window.innerHeight );
renderer.setClearColor( 0xB2B2CC, 1);
//renderer.autoClearColor = false;
//renderer.autoClearDepth = false;

// а...
document.body.appendChild( renderer.domElement );

var driverDomElement = renderer.domElement;

/* унесено... ветром в DRiverControls 
var stats;
//la_require("http://threejs.org/examples/js/libs/stats.min.js", function() {
la_require("three.js/examples/js/libs/stats.min.js", function() {
		stats = new Stats();
				stats.domElement.style.position = 'absolute';
				stats.domElement.style.bottom = '2px';
				stats.domElement.style.right = '2px';
				
				document.body.appendChild( stats.domElement );
} );

// http://learningthreejs.com/blog/2013/06/25/monitor-rendering-performance-within-threejs/
var rendererStats;
la_require("threex.rendererstats.js", function() {
        rendererStats  = new THREEx.RendererStats()
        
        rendererStats.domElement.style.position   = 'absolute'
        rendererStats.domElement.style.bottom  = '52px'
        rendererStats.domElement.style.right    = '2px'
        document.body.appendChild( rendererStats.domElement )
});
*/


    // в js объекты не могут быть ключами, печалько
    // http://www.timdown.co.uk/jshashtable/
    // Поэтому
    // objectsToRerender это массив из ячеек вида [объект,(таблица действий)]
    var objectsToRerender = [];

    function getObjDeeds( o ) {
      // меняем ключ на базовый объект. потому, что тот базовый объект тоже может вызывать makeLater, но уже с ключем-собой, 
      // и получится двойной вызов - один от наследного объекта, а второй от базового. Пример:
      // spheres.indices = x; -> повлечет makeLater(spheres);   spheres.material = y; -> повлечет makeLater(базовый объект)
      if (o && typeof(o.threeJsSceneObject) !== "undefined") {
        o = o.threeJsSceneObject;
        //console.log( "getObjDeeds downgrades");
      }

      //console.log("getObjDeeds performs lookup, objectsToRerender.length=",objectsToRerender.length);
      for (var i=0; i<objectsToRerender.length; i++) 
        if (objectsToRerender[i][0] === o) {
          //console.log( "getObjDeeds found object, returning");
          return objectsToRerender[i];
        }
      //console.log("getObjDeeds lookup found nothing, adding object");
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
      //console.log( "makeLater key=",key, "o._uniqueId=",o._uniqueId, "o=",o );
      
      var qq = objectsToRerender.length;
      var deeds = getObjDeeds( o );
      //console.log("deeds=",deeds);
      /*
      if (qq < objectsToRerender.length) {
        console.log("this makeLater added new object to queue, so objectsToRerender.length=",objectsToRerender.length);
        console.trace();
      }
      */

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
      //if (objectsToRerender.length > 0)  console.log("doScheduledPrerenderTasks. ************** objectsToRerender.length=",objectsToRerender.length);
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

function render() {
    threejs_sceneDelta = clock.getDelta();
    threejs_sceneTime = clock.elapsedTime;
    
    //var event = new Event('render');
    var event = { type: 'render' }
    scene.dispatchEvent(event); // Sm RenderTick.qml
    
    doScheduledPrerenderTasks();
  
    if (vrControl) vrControl.update();
    
    //sceneControl.update();
  
    selectedRenderer.render( scene, camera );
    ///renderer.render( scene, camera );
    // console.log("render called");
}

function animate() {
  renderer.animate( render ); 
}

animate();

function threeJsWindowResize() {
//console.log(">>>>>>>>>>>>>>>>>>>>>> threeJsWindowResize" );
				camera.aspect = window.innerWidth / window.innerHeight;
				camera.updateProjectionMatrix();
				
				if (selectedRenderer.setSize)
  				  selectedRenderer.setSize( window.innerWidth, window.innerHeight );

  				if (selectedRenderer.setViewport) {
  				  selectedRenderer.setViewport(0, 0, window.innerWidth, window.innerHeight );
//  				                  console.log(777);
  				}
  				if (selectedRenderer.setScissor)
  				  selectedRenderer.setScissor(0, 0, window.innerWidth, window.innerHeight );
}

window.addEventListener( 'resize', threeJsWindowResize, false );
// nooneed - resize event is working window.addEventListener( 'mozfullscreenchange', threeJsWindowResize, false );
// window.addEventListener( 'webkitfullscreenchange', threeJsWindowResize, false );
// http://robertnyman.com/2012/03/08/using-the-fullscreen-api-in-web-browsers/


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
