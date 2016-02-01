Item {
  anchors.fill:parent

  TabView {
    anchors.fill:parent
    anchors.bottomMargin: 25
    id: tabview

    Tab {
        title: "Video"
        Video {
          anchors.fill: parent
          width: 720

          //source: "http://jwst.nasa.gov/sciencevids/EvolutionoftheUniverse/Re-Ionization-Galaxy_Evolution_wideshot-1080p_ipod_sm.mp4"
          //source: "http://jwst.nasa.gov/sciencevids/PlanetaryEvolution/Nebula_to_cu_of_Protoplanetary_disc_ipod_sm.mp4"
          source: "http://images.all-free-download.com/footage_preview/webm/clouds_timelapse_129.webm"

          autoPlay: true
          controls: true

          //fillMode: VideoOutput.PreserveAspectFit
          //fillMode: VideoOutput.Stretch
          fillMode: VideoOutput.PreserveAspectCrop
        }
    }

    Tab {
        title: "Camera"
        Camera {
          anchors.fill: parent
          fillMode: VideoOutput.PreserveAspectCrop
          //fillMode: VideoOutput.Stretch
          active: tabview.currentIndex == 1
        }
    }

    Tab {
        title: "Camera & Video"
        Camera {
          anchors.fill: parent
          fillMode: VideoOutput.PreserveAspectCrop
          active: tabview.currentIndex == 2
          opacity: 0.75
          //z: -1
          id: camv2
        }
        Video {
          //z:-2
          opacity: 0.5
          width: camv2.width
          
          anchors.fill: parent
          source: "http://jwst.nasa.gov/sciencevids/EvolutionoftheUniverse/Re-Ionization-Galaxy_Evolution_wideshot-1080p_ipod_sm.mp4"
          autoPlay: true
          controls: true
          fillMode: VideoOutput.PreserveAspectCrop
          onStopped: play();
          onPositionChanged: {
            //trick if (position > 34000) seek(0);
            //console.log(position,duration);
          }
        }        
    }    

    
  }
  
}