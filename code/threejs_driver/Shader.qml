/* TODO

   Сделано
   1 назначить каждому объекту шейдера уникальный не-рандомный ключ.
   2 переименовывать uniform-переменные согласно ключу
     а потом еще variing надо будет тоже
     - это позволит делать цепочки шейдеров
   3 разобраться с коннектами и дисконнектами
   4 shaders-changed - переделываем материал
*/

Column {
  id: thatshader

  property var enabled: true

  property var vertex
  property var fragment

  property bool vertexOver: true
  property bool fragmentOver: true // прицепляться ли к "снизу" стандартного fragment-шейдера (=true), или это чистый шейдер (=false)

  property var ctag: "right"

  signal changed();

  onEnabledChanged: changed();
  onVertexChanged: changed();
  onFragmentChanged: changed();

  property var sceneTime: scene ? scene.sceneTime : 0
  property var scene: {
    var f = parent;
    //console.log(1);
    while (f) {
      if (f.findRootSpace) break;
      f = f.parent;
    }
    return f;
  }  

  onVisibleChanged: {
//    console.log("shader visible changed!");
  }
  
//  onChanged: { console.log("shader changed!"); }
  
///////////////////////////////////
  Component.onDestruction: enabled = false; 


  property var renamerId: getGlobalCounter();

// http://threejs.org/docs/#Reference/Renderers.WebGL/WebGLProgram  
// https://github.com/mrdoob/three.js/blob/cbb711950dab74bd8be6c8cf295296aa31f07e6c/src/renderers/shaders/ShaderLib.js  
// more correct seems this: https://github.com/mrdoob/three.js/tree/r88/src/renderers/shaders

  property var fragmentTemplate: "

BEFORE  

void main() {  
BODY
}
"

  property var vertexTemplate: "

BEFORE  

void main() {  
BODY
}
"

  // https://github.com/mrdoob/three.js/blob/r88/src/renderers/shaders/ShaderLib/meshphysical_vert.glsl
  // https://github.com/mrdoob/three.js/tree/r88/src/renderers/shaders/ShaderChunk
  
  // Короче говоря. Посмотрели мы на ихоновые шаблоны. И видим что
  // vec3 transformed = vec3( position );
  // ... различные изменения transformed..
  // vec4 mvPosition = modelViewMatrix * vec4( transformed, 1.0 );
  // итого, они там накапливают вовсю вектор transformed, а position это исходное значение
  // и потом уже оный transformed поступает на вход всякоему проецированию


  // производит подключение указанного списка шейдеров к целевому объекту, у которого уже назначен sceneMaterial
  // целевой объект не понятно зачем, но видимо зачем-то нужен
  
  function attachShaders( shaders, sceneMaterial, hosterObj ) {
//    console.log("Shader::attachShaders",shaders,hosterObj );
    
    // методы очистки уже прицепленного (там сейчас сигналы если что)
    if (hosterObj.shadersDetachFunc) {
      hosterObj.shadersDetachFunc(); hosterObj.shadersDetachFunc = undefined;
    }
    
    // part of feature: track attached objects
    hosterObj.shadersDetachFunc = function() {
      for (var i=0; i<shaders.length; i++)
        if (shaders[i].objectDetached)
            shaders[i].objectDetached( hosterObj );
    } // todo: onDestruction..
    
    // итак у нас есть цепочка shaders
    // в ней две подцепочки - vertex и fragment
    // соберем каждую. сбор означает - начать мержить их одна за другой слева на право.
    // а в случае vertex в конце прицепить еще и шейдер исходного материала.
    // Мерж означает. 
    // Мы идем в какой-то цепочке, vertex или frament.
    // Выделены объекты uniforms, attributes, beforemain код шейдера, maincode шейдера. 
    // Мерж шейдера - 
    // разбить его на 2 части - до-main и тулово-main.
    // приписать их снизу в beforemain, maincode и дополнить uniforms, attributes

    if (!shaders || shaders.length == 0) return;

  	var shaderIDs = {
  		MeshDepthMaterial: 'depth',
  		MeshNormalMaterial: 'normal',
  		MeshBasicMaterial: 'basic',
  		MeshStandardMaterial: 'standard',
  		MeshLambertMaterial: 'lambert',
  		MeshPhongMaterial: 'phong',
  		LineBasicMaterial: 'basic',
  		LineDashedMaterial: 'dashed',
  		PointsMaterial: 'points'
  	};    
  	
  	var basetype = shaderIDs[ sceneMaterial.origType || sceneMaterial.type ];
    if (!basetype) console.error("Shader.qml error: basetype not calculated, please check is my table correct?");
//  	console.log("basetype=",basetype);
    var baseshader = THREE.ShaderLib[ basetype ];
    if (!baseshader) console.error("Shader.qml error: baseshader not found, please check the table!");
    
    var acc = {};
    acc.uniforms = THREE.UniformsUtils.merge( [baseshader.uniforms] ); // THREE.UniformsUtils.merge([baseshader.uniforms,thisShaderUniforms]);
    acc.attributes = THREE.UniformsUtils.merge( [baseshader.attributes] ); // THREE.UniformsUtils.merge([baseshader.uniforms,thisShaderUniforms]);
    acc.sceneMaterial = sceneMaterial;
    
    for (var i=0; i<shaders.length; i++)
    {
      var sh = shaders[i];
      
      if (!sh) continue;

      if (!sh.changed) {
        //console.error("It seems your shader object is not shader. Please check it!",sh);
        continue;
      }
      
      // подключен ли сигнал шейдера к функции attachShaders целевого объекта?
      if (!sh.changed.isConnected( hosterObj, "attachShaders" )) {
          sh.changed.connect( hosterObj, "attachShaders" );
      }

      if (!sh.enabled) continue;
      if (sh.vertex) doAttach( sh, acc, "vertex",hosterObj  );
      if (sh.fragment) doAttach( sh, acc, "fragment",hosterObj );
      
      if (sh.objectAttached)
          sh.objectAttached( hosterObj );
    }

    // Итого у нас в структуре acc записаны совмещенные коды всех шейдеров
    // acc.vertex/acc.vertex_before и acc.fragment/acc.fragment_before
    // тут vertex это тело main а _before это декларативная часть.

//    if (!acc.vertex && !acc.fragment) return;
    
    var vertexShader;
    
    if (acc.vertex) { // дополним стд кодами
    
      var template;
      // 
      if (vertexOver) { // странно конечно, что режим выбора у нас определяется получается первым шейдером..
      
        var s = baseshader.vertexShader;

        // выяснено, что в tree-js шейдеры надо встраиваться перед их project-vertex инклюдом
        // еще выяснено что они накапливают данные теперь в переменной transformed
        // а мы исторически работаем с gl_Position.. поэтому скопируем данные из нее, а потом обратно.
        template = "BEFORE\n" + s.replace("#include <project_vertex>","\n    /**** viewlang begin ****/\ngl_Position=vec4( transformed, 1.0 );\nBODY\ntransformed=vec3( gl_Position.x, gl_Position.y, gl_Position.z );\n    /**** viewlang finish ****/\n#include <project_vertex>");
        
        // feature: points size
        if (template.match(/(viewlang finish[^]+)gl_PointSize\s+\=\s+size;/) && acc.vertex.match(/gl_PointSize\s+\=/)) {
          //console.log("!!!!!!!!!!!!!!!!!!!!!!!!!!1 feat found");
          // уберем копирование которое было стандартное
          template = template.replace(/(viewlang finish[^]+)(gl_PointSize\s+=\s+size;)/,"$1 /*commented out by viewlang... $2 ...*/");
          // [^] is a . for multiline.. https://developer.mozilla.org/ru/docs/Web/JavaScript/Reference/Global_Objects/RegExp#Special_characters_meaning_in_regular_expressions
          // debugger;
          // поставим свое копирование в самом начале, и т.о. шейдеры могут на него влиять
          template = template.replace("/**** viewlang begin ****/","/**** viewlang begin ****/\ngl_PointSize = size;" );
        }
        else {
          //debugger;
        }
      }
        else template = vertexTemplate;
      
      // no need to get it manually - template loaded from baseshader ok.
      // if (basetype == "points") template = pointsVertexTemplate;
        
      //var baseparts = splitCode( baseshader.vertexShader );
      //console.log("baseparts found=",baseparts);
 
      vertexShader = template.replace("BEFORE", acc.vertex_before ).replace("BODY", acc.vertex );
    }
    
    var fragmentShader;

    if (acc.fragment) { // дополним стд кодами
      if (fragmentOver)  
      { // режим, когда мы прицепляемся снизу к стандартному шейдеру
//        console.log("baseshader.fragmentShader=",baseshader.fragmentShader);
        var baseparts = splitCode( baseshader.fragmentShader );
//        console.log("baseparts found=",baseparts);
        var template = fragmentTemplate;
        fragmentShader = template.replace("BEFORE", baseparts[0] + "\n" + acc.fragment_before ).replace("BODY", baseparts[1] + "\n" + acc.fragment );
      }
      else
      { // чистый режим
        var template = fragmentTemplate;
        fragmentShader = template.replace("BEFORE", acc.fragment_before ).replace("BODY", acc.fragment );
      }
    }    
    
    if (sceneMaterial.type != "custom" && (vertexShader || fragmentShader) ) {
      sceneMaterial.origType = sceneMaterial.type;
      sceneMaterial.type = "custom";
    }
    // bug
    //debugger;
    if (sceneMaterial.uniforms)
      Object.assign( sceneMaterial.uniforms, acc.uniforms );
    else
      sceneMaterial.uniforms = acc.uniforms;
    
    // короче выходит material внутри себя копирует ссылку на material.uniforms, см initMaterial
    // а допом выходит что material.needsUpdate не приводит к перекопированию этой ссылки
    // очевидно это такой минибаг.. типа один раз выставили uniform-ы в материал и нефиг их потом обновлять..
    // ну засим используем object assign
    //console.error("sceneMaterial assigned new uniforms from shader generator",sceneMaterial);
    
    sceneMaterial.attributes = acc.attributes;
    
    // console.log(  "so vertexShader=",vertexShader);
    //console.log(  "so baseshader.vertexShader=",baseshader.vertexShader);
    
    sceneMaterial.vertexShader = vertexShader || baseshader.vertexShader;
    sceneMaterial.fragmentShader = fragmentShader || baseshader.fragmentShader;
    
//    console.log("baseshader.fragmentShader=",baseshader.fragmentShader);
//    console.log("generated vertexShader=",sceneMaterial.vertexShader);
//    console.log("generated fragmentShader=",sceneMaterial.fragmentShader);
    
    // https://github.com/mrdoob/three.js/wiki/Updates
    // надо выставить это в тру, иначе материал может не обновиться
    sceneMaterial.needsUpdate = true;
  }

  function doAttach( sh, acc, tip, hosterObj )
  {
     var basecode = sh[tip]; /// get shader.vertex or shader.fragment
     if (!basecode) return;

     var ooo = extractUniforms( sh, acc.sceneMaterial, basecode, hosterObj );
     var thisShaderUniforms = ooo.uniforms;
     var code = ooo.code;
       
     embedCodeToAccumulator( acc, tip, code );

     acc.uniforms = THREE.UniformsUtils.merge([acc.uniforms,thisShaderUniforms]);
  }
  
  // разбивает code на 2 части - декларативную и тулово, и приписывает их снизу в раздельные переменные в acc
  function embedCodeToAccumulator( acc, tip, code ) {

     var parts = splitCode( code );
     if (!parts) return;

     var before = parts[0];
     var body = parts[1];
     
     acc[tip+"_before"] = (acc[tip+"_before"] || "") + before;
     acc[tip] = (acc[tip] || "") + "{" + body + "}\n";
     // мы вставляем дополнительные скобочки
     // затем чтобы разные шейдеры не конфликтовали по поводу имен
     // переменных, которые они объявляют в теле body.

     return before;
  }

  // разбивает код (заданный строкой) на 2 части - до main и после.
  function splitCode(code) {
     //var re = /void\s*main\(\s*(void)*\s*\)/;
     var re = /void\s*main\([^)]*\)/;
     
     var parts = code.split( re );
     if (parts.length !== 2) {
       console.error("failed to split shader code to declarative and main part",code);
       return null;
     }
     parts[1] = parts[1].slice( parts[1].indexOf( "{" )+1 ); // уберем первую {
     parts[1] = parts[1].slice( 0,parts[1].lastIndexOf( "}" )-1); // уберем последнюю }
     //parts[1] = parts[1].trim();
     return parts;
  }  

  
  // прицепляется к изменению свойства uniform_property_name в объекте ownerObj (т.е. ownerObj это надо бы назвать trackedPropertyOwnerObj)
  // при этом объект, по которому ведется коннект, это hosterObj (имеется ввиду что hosterObj используется в роли объекта используемого для учета в слотах)
  // он подразумевается совпадает с объектом SceneObject, по заказу которого делался материал.
  // таким образом если этот объект удаляется, то должны почиститься его коннекты... не факт конечно.
  // а еще дополнительно мы отслеживаем, какой материал у этого объекта, и если он не совпадает с тем 
  // по которому был коннект, то тоже дисконнектимя. ееех жесть.
  function connectIt( ownerObj, sceneMaterial, uniform_property_name, renamed_name, hosterObj ) {
     //console.log("shader connect hosterObj=",hosterObj.$class,"uniform_property_name=",uniform_property_name,"sceneMaterial=",sceneMaterial);

           var handler = function() {
                //debugger;
                if (hosterObj.sceneObject && hosterObj.sceneObject.material && hosterObj.sceneObject.material !== sceneMaterial) {
                  console.log("i try to disconnect because material changed..",hosterObj);
                  ownerObj[ uniform_property_name+"Changed"].disconnect( hosterObj, handler );
                  return;
                }
                if (typeof( sceneMaterial.uniforms[ renamed_name ]) === "undefined") {
                  // нас грубо отцепили, возможно, переназначив шейдеры на что-то другое
                  console.log("i disconnect 2",handler);
                  ownerObj[ uniform_property_name+"Changed"].disconnect( hosterObj, handler );
                  return;
                }

                var q = ownerObj[ uniform_property_name ];
                var type = sceneMaterial.uniforms[ renamed_name ].type;
                if (type === "v2")
                  q = new THREE.Vector2( q[0],q[1] )
//                if (uniform_property_name != "sceneTime") debugger;
                
                sceneMaterial.uniforms[ renamed_name ].value = q;
//                if (uniform_property_name != "sceneTime") 
//                  console.log("shader signal assigned var",uniform_property_name, q,"renamed name",renamed_name ); //,"for object",hosterObj.$class, "closure material ",sceneMaterial,"obj material",hosterObj.sceneObject.material );
            }

            if (!ownerObj[ uniform_property_name+"Changed"]) {
              console.error("Shader: cannot find 'changed' signal for property",uniform_property_name );
              return;
            }
            ownerObj[ uniform_property_name+"Changed"].connect( hosterObj, handler );
            // отдельно запомним очищалку сигналов используемую "в общем"
            //debugger;
            var f = hosterObj.shadersDetachFunc;
            hosterObj.shadersDetachFunc = function() {
              ownerObj[ uniform_property_name+"Changed"].disconnect( hosterObj, handler );
              if (f) f();
            }
  }
  
  // возвращает: obj.uniforms и obj.newcode -- код с переименованными данными
  function extractUniforms( shaderObj, sceneMaterial, code, hosterObj ) {
  
        ///// prepare

        var uniforms = {};
        var renames = [];
        
        /*
        uniform float time;
        uniform vec2 resolution;
        */

        function appUniform( glsl_type, valfunc ) {
          var re,match;
          re = new RegExp ("^\\s*uniform.*" + glsl_type + "\\s+([a-z_0-9]+)","gim");
          //console.log("re=",re);
          while (match = re.exec(code)) {
            var name = match[1].slice(0);
            var renamed_name = name + "_sh" + shaderObj.renamerId;
            
            // object lookup 
            var dataObj = shaderObj;
            var dataName = name;

            if (typeof(dataObj[dataName]) === "undefined" && typeof(dataObj.$context[dataName]) !== "undefined") 
              dataObj = dataObj.$context;

            if (typeof(dataObj[dataName]) === "undefined") {
              console.error("Shader.qml error: property ",dataName," referenced in shader code not found in shader object!");
              continue;
            }
            // and connect to params
            // возможно dataObj следует вычислять через eval... хотя там есть вариации..
            if (dataObj[name].tag) { // this is Param?
              dataObj = dataObj[name];
              dataName = "value";
            }
            
            // go
            uniforms[ renamed_name ] = valfunc( dataObj, dataName, renamed_name );
            connectIt( dataObj, sceneMaterial, dataName, renamed_name, hosterObj );

            //console.log( "pusing",[ name, renamed_name ]);
            renames.push( [ name, renamed_name ] );
          }
        }

        /// detect uniforms part

        appUniform( "float", function (dataObj, name, renamed_name) {
          return { type: "f", value: dataObj[name] };
        });

        appUniform( "vec2", function (dataObj, name, renamed_name) {
          var q = dataObj[name];
          return { type: "v2", value: new THREE.Vector2( q[0],q[1] ) };
        });
        
        /////// rename part
        // console.log("renames=",renames);
        
        for (var i=0; i<renames.length; i++) {
          var name = renames[i] [0];
          var renamed_name = renames[i] [1];
          function replacer(match, p1, p2, p3, offset, string) {
            return p1 + renamed_name + p3;
          }
    
          var re = new RegExp( "([^a-z_0-9]+)(" + name + ")([^a-z_0-9]+)", "gi" );
          code = code.replace( re, replacer );
          // и еще разок
          code = code.replace( re, replacer );
        }

       return { uniforms: uniforms, code: code };
  }
  
property var pointsVertexTemplate: "
     
BEFORE

uniform float size;
uniform float scale;

#include <common>
#include <color_pars_vertex>
#include <fog_pars_vertex>
#include <shadowmap_pars_vertex>
#include <logdepthbuf_pars_vertex>
#include <clipping_planes_pars_vertex>

void main() {

    #include <color_vertex>
    #include <begin_vertex>
  
    float psize = size;
        
    BODY

    #include <project_vertex>
        
    #ifdef USE_SIZEATTENUATION
        gl_PointSize = psize * ( scale / - mvPosition.z );
        // возможно точки исчещают что эта штука в 0 обращается
        // gl_PointSize = size;
    #else
        gl_PointSize = psize;
    #endif
          
    #include <logdepthbuf_vertex>
    #include <clipping_planes_vertex>
    #include <worldpos_vertex>
    #include <shadowmap_vertex>
    #include <fog_vertex>
}
"

  /// feature: track attached objects
  
  signal objectAttached( object obj );
  signal objectDetached( object obj );
  
  property var objects: []
  // великий прикол в том, что объект массива [] будет разделяться между всеми шейдерами
  // вероятно это следствие того, что я сделал присваивание массивов по ссылке а не по значению
  
 
  onObjectAttached: {
    var arr = objects;
    var ob = obj;
    var i = arr.length;
    while (i--) {
      if (arr[i] == ob) {
        return; // objects exist
      }
    }
    
    objects = objects.concat( obj ); // тут присвоение а не пуш - это важно
  }
  
  onObjectDetached: {
    var arr = objects;
    var ob = obj;
    var i = arr.length;
    var hasChange = false;
    while (i--) { 
      if (arr[i] == ob) {
        arr.splice( i,1 );
        hasChange = true;
      }
      
    }
    if (hasChange)
        objectsChanged();
  }

}  
