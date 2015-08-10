Item {
  /// вход
  property var file
  property var mult: 20
  
  /// выход
  property var zones
  property var zonesCount: zones.length
  
  /// внутренность
  property var q: load()

  function load() {
    loadFile( file, function(data) {
      var lines = data.split("\n");
      console.log("file loaded, byte count=",data.length,"lines count=",lines.length);

      var zonedata = [];
      var result = [];
      
      for (var i=0; i<lines.length; i++) {
        var line = lines[i];

        if (/["]/.test(line)) continue; // пропускаем если есть "

        if (/^\s*ZONE\s+/.test(line)) {
          if (zonedata.length > 0) result.push( zonedata );
          zonedata = [];
          console.log("found new zone: ",line );
          continue;
        }

          /*
          var nums = line.split(/\s+/);
          zonedata.push( parseFloat(nums[1]) );
          zonedata.push( parseFloat(nums[2]) );
          zonedata.push( parseFloat(nums[3]) );
          */
        
          var myRe = /\s*([0-9e+-.]+)/g;      
          zonedata.push( parseFloat( (myRe.exec(line) || "0.0") [0] ) * mult );
          zonedata.push( parseFloat( (myRe.exec(line) || "0.0") [0] ) * mult );
          zonedata.push( parseFloat( (myRe.exec(line) || "0.0") [0] ) * mult );
           
      }
      
    if (zonedata.length > 0) result.push( zonedata );
    console.log( "load complete" );
    
    zones = result;

    }); // обработчик
  } // load
  
}