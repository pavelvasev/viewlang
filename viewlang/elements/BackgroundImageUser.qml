BackgroundImage {
    source: urla
    //aspect: true
    mixOpacity: 0.0
    mixOpacity: pMix.value/100
    //opacity: 1-pMix.value/100
    property var ctag: "right"

    property var urla: "" //: pFon.values[ pFon.value ]
    onUrlaChanged: { console.log("urla=",urla); console.trace(); }

    Param {
      valEnabled: false
      enableSliding: false
      id: pFon
      text: "Фон"
      tag: ctag
      onValueChanged: urla = pFon.values[ pFon.value ]

      values: [ "http://widefon.com/_ld/41/50310581.jpg", "http://4tololo.ru/files/images/201324101801106989.jpeg","http://7ly.ru/wp-content/uploads/2014/09/kosmos_05.jpg",
                /// planet
        
                "https://hdwallpapers.cat/wallpaper/shooting_stars_nebula_space_hd-wallpaper-1144370.jpg",
                "http://picsfab.com/download/image/76208/2048x1536_planeta-kosmos-zemlya.jpg",
                "http://hq-wallpapers.ru/wallpapers/6/hq-wallpapers_ru_space_29787_1920x1200.jpg",
                "http://www.rusif.ru/wallpaper-sb/wallpaper/kosmos-ss/zemlya%20-%20126.jpg",
                "http://wpapers.ru/wallpapers/Space/7852/1920x1440_%D0%9D%D0%B0%D0%B4-%D0%97%D0%B5%D0%BC%D0%BB%D0%B5%D0%B9.jpg",
                /// cosmo
                "http://images.forwallpaper.com/files/images/d/d5bd/d5bd4ce8/231614/nebula-stars-glow-constellation-cosmos.jpg",
                "http://www.blirk.net/wallpapers/1600x1200/space-wallpaper-14.jpg",
                "http://vicvapor.com/files/2014/02/Outer-Space-Wallpaper-Space-Stars.jpg",
                ""
              ]
    }
    

    Param {
      id: pMix
      text: "прозрачность canvas-a"
      tag: ctag      
      //visible:false
    }

    OpacityParam {
      text: "прозрачность фона"
      tag: ctag      
      value: 100
      visible: false
    }
    // решено пока так. картинка - прозрачность не меняется. если есть то есть. а вот прозрачность канвас-а настраиваем.

    FileParam {
      id: fil
      text: "файл фона"
      onFileChanged: {
        if (!file) return;
        console.log("file",file)
        
        if (file instanceof File) 
        {
          var reader  = new FileReader();
          reader.onloadend = function () {
            urla = reader.result;
          }
          reader.readAsDataURL(file);        
        }
        else
          urla = file;	

      }

      tag: ctag
    }

    Component.onCompleted: {
      console.log("fil.file=",fil.file);
    }

}
