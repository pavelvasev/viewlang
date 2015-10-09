Scene {
  id: myscene
  property var t: $basePath
    Text {
      text: "path5=" + $basePath
      y: 120
    }  
  Text {
    text: "path="+myscene.$basePath
  }
  Text {
    y: 30
    text: "path1="+$basePath
  }  
  Texter {
    y: 80
  }
  Points {
    id: p
    Text {
      text: "path2=" + $basePath
      y: 20
    }    
    
    property var q: loadFile( "points.txt", function(res) {
      var lines = res.split("\n");  
      var arr = [];
      for (var i=0; i<lines.length; i++) {
        var nums = lines[i].split(" ");
        if (nums.length == 3) {
         arr.push( parseFloat(nums[0]) );
         arr.push( parseFloat(nums[1]) );
         arr.push( parseFloat(nums[2]) );
        }
      }
      positions = arr;
    });
    
  }
}