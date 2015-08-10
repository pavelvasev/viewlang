$driver = { colors: 3 };

var driverDomElement = null; //renderer.domElement;

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
         qmlObject.make3d();
         return true;
      }
      return false;
    }
    