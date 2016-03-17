AppAppender
добавлятель произвольного числа qml-элементов, определяемых списком классов/урлей. Использует Loader.

AppChooser (fixedmix)
возможность загрузки 1го qml-файла из списка. При переключении старый выгружается. 
Плюс возможность редактировать код загруженного файла.
Загружает файл сам, через loadFile, и использует createQmlObject.

USE
```
import components.appmix

Item {
  AppAppender {
    apps: ["Button"]
  }
}
```