//import QtQuick 2.3
//import QtQuick.Controls 1.2

// http://doc.qt.io/qt-5/qml-qtquick-controls-combobox.html

Item {
    id: groupbox
    property var title: ""
    property alias contentItem: content

    default property alias newChildren: content.data

    width: childrenRect ? 14+radius*2 + childrenRect[0] : 200
    height: childrenRect? 14+radius*2 + childrenRect[1] : 50
    
    property var radius: 4

    property var border: true

    function computeChildrenRect()
    {
        var w=0,h=0;
        for (var i=0; i<content.children.length; i++)
        {
            var item = content.children[i];
            if (!item.visible) continue;
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

    /* Идеально было бы, если бы fieldset не был бы корявым и не содержал padding-ов и margin-ов.
       Тогда мы корневой item сделали бы field-set-ом. И даже contentItem не понадобилась бы.
       Хотя.. все-равно понадобилась бы, ибо в qml нет-у padding-ов. А почему вот?

       А теперь приходится хитрить и юлить. Создавать а) contentItem, чтобы получить padding-и для содержимого
       б) создавать итем с тэгом fieldset, чтобы получить красивую рамку.
       
       См заметки в ComboBoxF.qml
    */

    Item {
        id: fieldsetItem
        width: parent.width - 19 - radius*2 
        height: parent.height - 16 - 3*radius/4

        property var htmlTagName: "fieldset"
        
        Component.onCompleted: {
            legend = document.createElement("legend");
            fieldsetItem.dom.appendChild( legend );
            fieldsetItem.dom.style.cssText += "-webkit-border-radius: "+radius+"px;-moz-border-radius: "+radius+"px; border-radius: "+radius+"px; ";// padding: 0px;";
            if (!groupbox.border)
              fieldsetItem.dom.style.cssText += "border-width: 0px;"
            
            groupbox.titleChanged();

            //innerHTML = "<legend>"+title+"</legend>";
            //legend = groupbox.dom.firstChild;
        }
    }

    Item {
        x: (groupbox.width - fieldsetItem.width)/2 -5
        y: 8 + (groupbox.height - fieldsetItem.height)/2
        width: fieldsetItem.width 
        height: fieldsetItem.height

        id: content
    }


  /*
  HtmlTagItem {
    type: "fieldset"
    style: "....."
    
  }*/

}

