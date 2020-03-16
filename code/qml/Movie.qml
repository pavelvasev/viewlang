/*
  Предназначение - генерация анимации
  
  По таймеру увеличивает значение параметра на заданную величину.
  
  Примечание. Параметры во вьюланг идут в 2х режимах - простые числовые и списочные.
  С числовыми все хорошо и понятно - есть минимум, максимум, шаг, и значение.
  Со списочными - идет список значений.
  Пока не понятно, как поступать с их анимацией. А именно, что вводить в стартовом,
  максимальном, и шаговом значениях в анимации - значения индексов или значения из списков.
  Значения из списков заманчивы - человеку удобнее опираться на реальность, а не на индексы.
  Но это не сработает если значения в списках строковые или нелинейные числовые.
  Пока непонятно, как быть.
  
*/

Item {
    ////////////////////////
    property var recorderWindow
    property bool doRecord: cbRecord.checked && recorderWindow && !recorderWindow.closed 

    property bool processActive: false
    property var processParam
    property var processMin
    property var processMax
    property var processStep
    
    property int subcounter: 0
    property int loopcounter: 0

    onProcessActiveChanged: {
      if (qmlEngine.rootObject.$properties["animationActive"]) qmlEngine.rootObject.animationActive = processActive;
      if (qmlEngine.rootObject.$properties["animationRecord"]) qmlEngine.rootObject.animationRecord = doRecord;
    }

    function makeShot() {
        if (doRecord && loopcounter == 0) {
          // threejs
          console.log("making shot and sending to recorder window");
          var img = renderer.domElement.toDataURL("image/png");
          recorderWindow.postMessage( {cmd:"appendDataUrl",args:[img]},"*");
        }
    }

    RenderTick {
      enabled: processActive && qmlEngine.rootObject.propertyComputationPending == 0
      onAction: {

        subcounter = subcounter+1;
        if (subcounter % 5 !== 0) return;
        
        // dice: pending..
        // if (qmlEngine.rootObject.$properties["propertyComputationPending"] && qmlEngine.rootObject.propertyComputationPending > 0) return;

        makeShot(); // of previous value
        
        processParam.value = processParam.value + processStep;

        if ( (processStep > 0 && processParam.value > processMax) || ((processStep < 0 && processParam.value < processMin))) {

          // BUG. here we stop recording. But actial rendering will be done on the next step. So last shot is lost.
        
          loopcounter = loopcounter+1;
          if (loopcounter > 10)
            processActive = false;
          else
            processParam.value = processMin;

          if (loopcounter == 1 && doRecord) {
            console.log("SENDING finish signal and focus befor");
            // hack from http://stackoverflow.com/questions/2758608/window-focus-not-working-in-google-chrome
            // не работает этот хак...
            recorderWindow.blur();
            setTimeout( function() {
              recorderWindow.focus();
              recorderWindow.postMessage( {cmd:"finish"},"*");
            }, 0 );
            
          }
          
        } // if
        
        //console.log(subcounter,processParam,processParam.value);
      }
    }
    ////////////////////////

    Button {
        text: processActive ? "Стоп" : "Анимация.."
        width: 88
        property var tag: controlsTag
        onClicked: !dlg.visible ? open() : dlg.close();
    }

    function prepare() {
      processActive = false;
    
      var acc=[];
      var params = sceneObj.rootScene.gatheredParams;
      // console.log("see params=",params );
      // params = params.sort(function (a, b) { var x=(a.animationPriority || 10000); var y=(b.animationPriority || 10000); if (x<y) return -1; if (x>y) return 1; return 0; } );
      for (var i=0; i<params.length; i++) {
          if (!params[i].enabled) continue;
      
          //console.log(params[i].animationPriority, params[i]);
          acc.push( params[i].text || params[i].target.text );
      }
      comboparams.model = acc;
      
      updateminmax();

      if (cbRecord.checked && (!recorderWindow || recorderWindow.closed)) cbRecord.checked = false;
    }

    function open()
    {
      prepare();      
      dlg.open();
    }
    
    /*
    property var targetParam: {
      var q = sceneObj.rootScene.gatheredParams[ comboparams.currentIndex ];
      return q ? q.target : null;
    }
    onTargetParamChanged: {
      paramStart.value = targetParam.min;
      paramFinish.value = targetParam.max;
    }
    */
    function updateminmax(force) {
      var q = sceneObj.rootScene.gatheredParams[ comboparams.currentIndex ];
      if (!q) { console.log("k1"); return; }
      var targetParam = q.target;
      if (!targetParam) { console.log( "k2" ); return; }
      if (targetParam !== processParam || force) {
        paramStart.text = targetParam.min;
        //paramStart.text = targetParam.value; // try start from current value..
        paramFinish.text = targetParam.max;      
        paramStep.text =  targetParam.animationStep ? targetParam.animationStep : targetParam.step;
        paramStartLabel.note = targetParam.values ? "(порядковый номер)" : "(значение)"
      } else console.log("k3");
    }
    function setcurrentv() {
      var q = sceneObj.rootScene.gatheredParams[ comboparams.currentIndex ];
      if (!q) { console.log("k1"); return; }
      var targetParam = q.target;
      if (!targetParam) { console.log( "k2" ); return; }
      paramStart.text = targetParam.value;
    } 
    function setminv() {
      var q = sceneObj.rootScene.gatheredParams[ comboparams.currentIndex ];
      if (!q) { console.log("k1"); return; }
      var targetParam = q.target;
      if (!targetParam) { console.log( "k2" ); return; }
      paramStart.text = targetParam.min;
    }     

    function gogo() {
      var q = sceneObj.rootScene.gatheredParams[ comboparams.currentIndex ];
      if (!q) return;
      var targetParam = q.target;
      if (!targetParam) return;
      if (!paramStart.text || !paramFinish.text || !paramStep.text) return open();

      processMin = parseFloat( paramStart.text );
      processMax = parseFloat( paramFinish.text );
      processStep = parseFloat( paramStep.text );
      
      processParam = targetParam;
      processParam.value = processMin;

      loopcounter = 0;

/*      
              if (cbRecord.checked) {
                if (!recorderWindow || recorderWindow.closed) {
                    recorderWindow = window.open( "http://pavelvasev.github.io/simple_movie_maker/","_blank", "width=1200, height=700" );
                    //debugger;
								    //recorderWindow = window.open( "file://D:/GitHub/simple_movie_maker/index.html","_blank", "width=1200, height=800" );
								    console.log("opened recorderWindow=",recorderWindow);
                    
                }
              }
*/              

      if (doRecord) recorderWindow.postMessage({cmd:"reset"},"*");

      //makeShot();

      processActive = true;
      console.log( "so i start process");
    }

    function toggle() {
      if (processActive) processActive = false; else gogo();
    }

    function stop() {
      processActive = false;
    }
    
    SimpleDialog {
      title: "Выбор параметра анимации"
      id: dlg
      opacity: 0.8

      Column {
        ComboBox {
          width: 200
          id: comboparams
          onCurrentIndexChanged: updateminmax(true)

        }

        Text {
          text: "стартовая позиция " + note
          id: paramStartLabel
          property var note: ""
        }
        Row {
          spacing: 10
          TextField {
            id: paramStart
            width: 185
          }
          Button {
             text: "cur"
             //onClicked: setminv();
             onClicked: setcurrentv();
          }          
          Button {
             text: "min"
             onClicked: setminv();
             //onClicked: setcurrentv();
          }          

        }
        Text {
          text: "конечная позиция"
        }
        TextField {
          id: paramFinish
        }
        Text {
          text: "шаг"
        }
        TextField {
          id: paramStep
        }        

        Text {
          text: " "
        }

        Row {
          Button {
            text: "Поехали"
            width: 200
            onClicked: {
              dlg.close();
              gogo();
            }
          }
          Text { 
            y:3
            text: "   ctrl+m"
          }
          CheckBox {
            text: "Запись видео"
            id: cbRecord
            onCheckedChanged: {
              if (checked) {
  
                if (!recorderWindow || recorderWindow.closed) {
                    recorderWindow = window.open( "about:blank","_blank", "width=1200, height=700" );
                    recorderWindow.opener = null;
                    recorderWindow.document.location = "http://pavelvasev.github.io/simple_movie_maker/";
                    // we have to use 3 steps, so Chrome will move this new window in separate process.

                    //recorderWindow = window.open( "http://pavelvasev.github.io/simple_movie_maker/","_blank", "width=1200, height=700" );
                    //debugger;
								    //recorderWindow = window.open( "file://D:/GitHub/simple_movie_maker/index.html","_blank", "width=1200, height=800" );
								    console.log("opened recorderWindow=",recorderWindow);
                    
                }
  
              }
            }
          }

        }
       
        /*
        Param {
          text: "минимум"
          min: targetParam.min
          max: targetParam.max
          value: targetParam.min
        }
        */
      }

    }
}