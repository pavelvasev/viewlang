/*
import QtQuick 2.2
import QtQuick.Controls 1.1
import QtQuick.Window 2.1

import QtQuick.Layouts 1.0
*/

SceneObject {
    id: thisspace
    
    property alias renderGroups: renderGroupsA

    property var tag: "space"
    property var refinedSelf: false

    property var topRenderGroup: null
    
    property alias toolbarWidgets: toolbarWidgetsA
    Row {
        x: 10
        y: 5
        id: toolbarWidgetsA
        
    //anchors.right: parent.right
    //anchors.left: parent.left        

        // Layout.fillWidth: true
        //anchors.leftMargin: 10
        //anchors.topMargin: 10

        //height: 50

        z:5

        spacing: 5

        anchors.margins: 10
    }

    Rectangle {
        visible: toolbarWidgets.height > 0 && toolbarWidgets.visible
        
        anchors.fill:toolbarWidgets
        //anchors.left:toolbarWidgets.left-5
        anchors.leftMargin:-5
        anchors.rightMargin:-5

        anchors.topMargin:-1
        anchors.bottomMargin:-1

        z: 4
        //opacity: 0.0
        //opacity: 0.2
        /// also good:
        opacity: 0.5
        color: "#eeeeee"
    }

    Item {
        id: renderGroupsA
        //anchors.fill: parent
        anchors.left: leftWidgets.right
        anchors.top: toolbarWidgets.bottom
        anchors.bottom: parent.bottom
//        anchors.right: parent.right
        anchors.right: Math.min( rightWidgets.left,rightBottomWidgets.left)
        anchors.margins: 10
        anchors.topMargin: 8
        anchors.bottomMargin: 42

//        x: leftWidgets.x + 
//        y: 50
//        width: 300
//        height: 300
//        bottom: 50
//        right: 50
    }

    property alias leftWidgets: leftWidgetsA
    property alias leftWidgetsRect: leftWidgetsRect2
    Column {
        id: leftWidgetsA
        z: 2

        /*
    anchors.left: parent.left
    anchors.top: parent.top
    anchors.bottom: parent.bottom
*/    
        x:10
        //    y:10 + toolbarWidgets.height
        anchors.top: toolbarWidgets.bottom
        //    anchors.topMargin: 10

        anchors.margins: 10
        
        height: Math.min( 25 + implicitHeight, parent.height-50 );
        css.overflowY: "auto";
        css.overflowX: "hidden";
        css.pointerEvents: "all";        
    }

    Rectangle {
        id: leftWidgetsRect2
        visible: leftWidgets.height > 0 && leftWidgets.visible

        anchors.fill:leftWidgets

        //anchors.left:leftWidgets.left-5
        anchors.leftMargin:-5
        anchors.rightMargin:-5
        
        anchors.topMargin:-2
        anchors.bottomMargin:-2

        z: 1
        opacity: 0.2 // специально такое низкое значение, чтобы в глаза не билось. Для тулбара сделано побольше, там можно
        color: "#eeeeee"
    }

    property alias rightWidgets: rightWidgetsA
    Column {
        
        id: rightWidgetsA
        z: 2
        //y: 10 + toolbarWidgets.height
        anchors.top: toolbarWidgets.bottom

        anchors.right: parent.right
        anchors.margins: 10
        
        //height: Math.min( 25 + implicitHeight, parent.height-25-rightBottomWidgets.height );
        // сие есть старый алгоритм
        
        height: Math.max( 0, Math.min( 25 + implicitHeight, parent.height-25-rightBottomWidgets.height-45 ) )
        // получается мы делаем что правые нижние виджеты наступают на эту.
        // ну и ладно, кто-то должен уступить
        // Math.max добавлен чтобы больше 0 хотябы было
        
        // width делаем чтобы scroll не накладывался
        width: 18 + implicitWidth
        
        css.overflowY: "auto";
        css.overflowX: "hidden";
        css.pointerEvents: "all";
        
        
/*        move: Transition {
            NumberAnimation { properties: "x,y"; duration: 1000 }
        }
*/        
        
    }
    
    Rectangle {
        visible: rightWidgets.height > 0 && rightWidgets.visible
        anchors.fill: rightWidgets

        anchors.leftMargin:-5
        anchors.rightMargin:-5

        anchors.topMargin:-2
        anchors.bottomMargin:-2

        z: 1
        opacity: 0.2 // специально такое низкое значение, чтобы в глаза не билось. Для тулбара сделано побольше, там можно
        color: "#eeeeee"
    }

    property alias rightBottomWidgets: rightBottomWidgetsA
    Column {
        
        id: rightBottomWidgetsA
        z: 2 // -100 idea по клику на mousearea менять ето и прозрачно
        anchors.bottom: parent.bottom-5

        anchors.right: parent.right
        anchors.margins: 10
        
        // с этим разбираться долго, что-то глючит в нашем царстве..
        //css.overflowY: "auto";
        //css.overflowX: "hidden";
        //css.pointerEvents: "all";
        
    }
    
    Rectangle {
        visible: rightBottomWidgets.height > 0 && rightBottomWidgets.visible
        anchors.fill: rightBottomWidgets

        anchors.leftMargin:-5
        anchors.rightMargin:-5

        anchors.topMargin:-2
        anchors.bottomMargin:-2

        z: 1 //-100
        opacity: 0.2 // специально такое низкое значение, чтобы в глаза не билось. Для тулбара сделано побольше, там можно
        color: "#eeeeee"
    }    
    

    property alias bottomWidgets: bottomWidgetsA
    Row {
        id: bottomWidgetsA
        x: 10
        Component.onCompleted: bottomWidgetsA.dom.className = "bottomWidgetsA";
        //console.log("qqqqq",bottomWidgetsA.dom);
        //dom.class: "bottom_widgets"

        anchors.bottom: parent.bottom
        z:5
        spacing: 5

        anchors.margins: 10
    }

    Rectangle {
        visible: bottomWidgets.height > 0 && bottomWidgets.visible
        
        anchors.fill: bottomWidgets
        anchors.leftMargin:-5
        anchors.rightMargin:-5

        anchors.topMargin:-1
        anchors.bottomMargin:-1

        z: 4
        opacity: 0.5
        color: "#eeeeee"
    }    
    
    Component.onCompleted: refineSelf();

    function listToArray(l) {
        var r = [];
        for (var i=0; i<l.length; i++)
            r.push( l[i] );
        return r;
    }

    // детям можно иметь атрибут tag_priority.. он будет уменьшаться тогда.
    function sortArrayByPriority(arr) {
      for (var i=1; i<arr.length; i++)
        if (arr[i].tag_priority && arr[i].tag_priority > 0 && (isnan(arr[i-1].tag_priority) || arr[i].tag_priority > arr[i-1].tag_priority ) ) {
          //debugger;
          //console.log(">>>>>>>>>>>>>>>>>>>>>>>>>>> see arr[i].tag_priority=",arr[i].tag_priority);
          arr[i].tag_priority = arr[i].tag_priority - 1;

          var q = arr[i-1];
          arr[i-1] = arr[i];
          arr[i] = q;

          i = 0; 
        }
        return arr;
    }

    function childsToArray(c) {
        return listToArray( c.children );
    }

    function refineSelf() {

        refine(this);
        refinedSelf=true;
    }

    function checkSource(c) {
//      console.log("!!!!!!!!! found tagged item ",c);
      // сохраняет source как значение, а не как биндинг
      // это важно, тк часто мы юзаем source, который как биндинг назначен в parent, а в refine мы parent-а меняем
      if (c.source && c.source === c.parent)
        c.source = c.parent;

      // второе - сохраним свойство parent как c.oldSpaceParent. Это используется в ParamScopeFinder.
      if (!c.oldSpaceParent)
         c.oldSpaceParent = c.parent;
    }
    

    function refine( space ) {

        // console.log( "refine.. space=",space," this=",this );
        // console.trace();

        var queue = listToArray( space.children );

        while (queue.length > 0) {
            var c = queue.splice( 0,1 ) [0];
            var t = c.tag;

            if (t && !c.tagConnected) {
              c.tagConnected = true;
              c["tagChanged"].connect( c,function() {
//                console.log( "tag changed:",this.tag,arguments);
                qmlEngine.rootObject.refineSelf ? qmlEngine.rootObject.refineSelf() : 0;
//              debugger;
              } );
            }

            //if (c.title && c.tag )
            //console.log(c,t, c.title );
//            if (t)
//            console.log( c.text,t );
            

            var oldparent = c.parent;
            
            if (t == "base") {
                // base у нас это renderGroup так отмечаются

                // *** соединяем лучи. ***
                // считается, что тегом base обозначены только рендер-группы. У них же есть свойство forwardGroup

                
                // console.log( " *** linking rays *** space.topRenderGroup=",space.topRenderGroup,"c=",c);

                c.forwardGroup = space.topRenderGroup;
                space.topRenderGroup = c;
                
                //var newObject = Qt.createQmlObject('import QtQuick 2.2; Item { anchors.fill:parent; opacity: thisspace.opacity; visible: thisspace.visible; property var tag: "base" }',  renderGroups, "cmmSpace1");

                var oldParentTag = c.parent.tag;
                //c.parent = newObject;
                checkSource(c);
                c.parent = renderGroups;

                //if (oldParentTag != "base") {

                    // Проход по детям нужен, потому что мы можем внедрять в RenderGroup какие-то элементы управления.?
                    // Ну да. А до рендер-группы этой мы смогли дойти только потому, что ее приложение нас туда пустило (указав tag:export)
                    queue = sortArrayByPriority( listToArray( c.children ) ).concat(queue);
                //}
            }
            else
                if (t == "left") {
                    //eh var newObject = Qt.createQmlObject('import QtQuick 2.2; Column { visible: thisspace.visible; property var tag: "left" }',  leftWidgets, "cmmSpace2");
                    //eh c.parent = newObject;
                    checkSource(c);
//                    console.log("adding item to left widgets. current leftWidgets child count = ",leftWidgets.children.length );
                    c.parent = leftWidgets;
                    // leftWidgets.layoutChildren();
                }
                else
                if (t == "leftOpacity") {
                    //eh var newObject = Qt.createQmlObject('import QtQuick 2.2; Column { opacity: thisspace.opacity; visible: thisspace.visible; property var tag: "leftOpacity" }',  leftWidgets, "cmmSpace2");
                    //var newObject = Qt.createQmlObject('import QtQuick 2.2; Column { visible: thisspace.visible; property var tag: "left" }',  leftWidgets, "cmmSpace2");

                    //eh c.parent = newObject;
                    checkSource(c);
                    c.parent = leftWidgets;
                }                
                else
                    if (t == "right") {
                        //var newObject = Qt.createQmlObject('import QtQuick 2.2; Column { visible: thisspace.visible; anchors.right: parent.right; property var tag: "right" }',  rightWidgets, "cmmSpace3");
                        // c.parent = newObject;
//                        debugger;
                        checkSource(c);
                        c.parent = rightWidgets;

                    }
                    else
                        if (t == "top") {
                            //var newObject = Qt.createQmlObject('import QtQuick 2.2; Column { anchors.verticalCenter: parent.verticalCenter; visible: thisspace.visible; property var tag: "top" }',  toolbarWidgets, "cmmSpace4");

                            // Проблема в том, что если "c" это уже Column, то в тот момент когда мы "c" подцепим к newObject,
                            // который тоже Column, то qml начнет ломаться - нельзя в Column вставлять объекты с anchors.verticalCenter

                            //c.anchors.verticalCenter = undefined;
                            //c.parent = newObject;
                            checkSource(c);
                            c.parent = toolbarWidgets;
                        }
                        else
                        if (t == "bottom") {
                            checkSource(c);
                            c.parent = bottomWidgets;
                        }
                        else
                        if (t == "rightbottom") {
                            checkSource(c);
                            c.parent = rightBottomWidgets;
                        }                        
                        else {
                            if (c.children && t != "space" && !c.refineDisabled) { // && c.visible  c.visible - типа не входим, если область отключена.. забавно..
//                                console.log("adding children to queue of object ",c.id,c);
                                // Мы не входим внутрь других space-ов, там своя жизнь
                                // Но те space-ы могут переопределить tag, и тогда мы экспортируем их содержание
                                
                                //queue = queue.concat( listToArray( c.children ) );
                                // делаем обход в глубину... то есть приделываем  вперед списка
                                queue = sortArrayByPriority( listToArray( c.children ) ).concat(queue);
                 
                                //console.log( "queue=",queue);
                            }
//                            else console.log("!!!!!!!!!!!! disabled entereing into c=",c.id,c);
                         }

        } // while
    }

    function addSpace(otherspace) {
        refineSelf();
        refine( otherspace );

    /*
    for (var i=0; i<otherspace.renderGroups.children.length; i++)
    {
      var c = otherspace.renderGroups.children[i];
      c.parent = renderGroups;
    }

    for (var i=0; i<otherspace.leftWidgets.children.length; i++)
    */

    }

   function findRootSpace() {
      var foundRoot = this;
      var o = this;
      while (o = o.parent) {
        if (o.findRootSpace) 
          foundRoot = o;
      }
      //console.log("findRootSpace foundRoot=",foundRoot);
      return foundRoot;
   }

   function refineAll() {
     var sp = findRootSpace();
     
     if (sp) 
       sp.refineSelf();
   }    

   function walkChildren( child, func )
   {
     func( child );
     var chi = child.children;
     for (var i = 0; i < chi.length; i++)
       walkChildren( chi[i], func );
   }

}
