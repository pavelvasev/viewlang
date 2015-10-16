# Обработка пересечений

У всех визуальных объектов сцены есть метод `intersect( pointOnScreen )`, где pointOnScreen произвольный объект с полями x, y.
Пример использования (sp - айди некоего визуального объекта):
```
var r = sp.intersect( sceneMouse );
if (r) {  
  console.log( [ r.point.x,r.point.y,r.point.z ] );
  console.log( "индекс примитива", r.index )
}  
```  

# Обработка кликов мышкой
На сцену надо добавить объект `SceneMouseEvents`, который содержит сигналы мышки. Каждый сигнал несет аргументы: sceneMouse - 
```
SceneMouseEvents {
    onDoubleClicked: console.log( sceneMouse, event );
    onPositionChanged: console.log( sceneMouse, event );
    onClicked: console.log( sceneMouse, event );
}
```
