//import QtQuick 2.3
//import QtQuick.Controls 1.2

/*
   Попытка создать GroupBox напрямую через fieldset
   В этом случае не надо даже contentItem реализовывать, и весь код проще.
   В принципе работает, см. тесты groupboxes.qml
   И код правда проще, по сравнению с GroupBox.qml

   Но выяснилось.
   1. fieldset по факту рисуется шире, чем ему указано в стиле width,height.
   Значит в qmlweb-е надо ставить хук и выставлять высоту-ширину "уже", чем указано в пропертях.
   См строку 1800 в qtcore.js

   2. Надо добавить в qmlweb фичу padding, чтобы сдвигать детей. 
   Учет этого padding похоже надо делать в updateHGeometry 
 
   Полезные строки в qtcore.js
   1555 - createElement
   1800 - width to dom
*/

// http://doc.qt.io/qt-5/qml-qtquick-controls-combobox.html
Item {
    id: groupbox
    property var title: ""
    property alias contentItem: groupbox

    width: childrenRect ? 30 + childrenRect[0] : 200
    height: childrenRect? 30 + childrenRect[1] : 50

    property var htmlTagName: "fieldset"

    function computeChildrenRect()
    {
        var w=0,h=0;
        for (var i=0; i<contentItem.children.length; i++)
        {
            var item = contentItem.children[i];
            w = Math.max( w, item.x + item.width );
            h = Math.max( h, item.y + Math.max( item.implicitHeight,item.height) );
        }
        return [w,h];
    }

    property var childrenRect: computeChildrenRect();
    property var legend

    onTitleChanged: {
        if (legend) {
            legend.innerHTML = title;
        }
    }

        Component.onCompleted: {
            legend = document.createElement("legend");
            groupbox.dom.appendChild( legend );
            groupbox.dom.style.cssText += "-webkit-border-radius: 8px;-moz-border-radius: 8px; border-radius: 8px;";// padding: 0px;";margin: 0px;

            groupbox.titleChanged();

            //innerHTML = "<legend>"+title+"</legend>";
            //legend = groupbox.dom.firstChild;
        }


}

