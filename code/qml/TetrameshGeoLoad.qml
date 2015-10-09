SceneObject {
    property var src // : "init0.geo"
    
    property var stage: 0
    property var numPositions
    property var indicesA
    property var positionsA
    property var counter

    property var indices
    property var positions
    
    property var bpositions: loadit();
    function loadit() {
      if (!src) return;
      stage = 0;
      //console.log("src=",src);

      loadFile(src, function(res) {  // Lazy.makeHttpRequest(src).lines().each( function(line) { 
       console.log("got res ",res.length);
       res = res.split("\n");
       console.log("got res ",res.length);       
       for (var i=0; i<res.length; i++) {
        var line = res[i];
      
       if (stage == 0 && line.match(/coordinates/)) { 
         stage = 1; continue; 
       }
       if (stage == 1) { 
         numPositions = parseInt( line );
         positionsA = [];
         positionsA.length = 3 * numPositions; 
         stage = 2; counter=0;
         console.log("loader: numPositions=",numPositions);  
         continue;
       };
       if (stage == 2) {
         var val = parseFloat(line);
         if (isNaN(val)) {
           console.log("TetrameshGeoLoad.qml: vershina position N",counter," x value isNaN! line=",line,"line number=",i+1);
         }
         positionsA[ 0+3*counter ] = val; 

         counter++;
         if (counter >= numPositions)
         {
           stage = 3;
           counter = 0;
         }
         continue;
       }
       if (stage == 3) {
         var val = parseFloat(line);
         if (isNaN(val)) {
           console.log("TetrameshGeoLoad.qml: vershina position N",counter," y value isNaN! line=",line,"line number=",i+1);
         }
         positionsA[ 1+3*counter ] = val; 

         counter++;
         if (counter >= numPositions)
         {
           stage = 4;
           counter = 0;
         }
         continue;
       }       
       if (stage == 4) {  // z
         var val = parseFloat(line);
         if (isNaN(val)) {
           console.log("TetrameshGeoLoad.qml: vershina position N",counter," z value isNaN! line=",line,"line number=",i+1);
         }
         positionsA[ 2+3*counter ] = val; 
         
         counter++;
         if (counter >= numPositions)
         {
           stage = 5;
           counter = 0;

           positions = positionsA;
/*
           for (var i=0; i<positionsA.length; i++) { 
             if (typeof(positionsA[i]) === "undefined") { console.log("TetranesgGeoLoad: position undefined! i=",i); } 
           }
*/           
           // debugger;
           // write( positionsA.toJSON() );
         }
         continue;
       }       
       if (stage == 5) {
         var ok = line.match(/tetra/);
         if (!ok) { 
           console.log("TetrameshGeoLoad: word 'tetra' not found! text line=",line);
           continue;
         }
         stage = 6;
         continue;
       }
       if (stage == 6) {
         numPositions = parseInt(line);
         console.log("loader: num of tetras = ",numPositions);
         indicesA = [];
         indicesA.length = numPositions*4;
         stage = 7;
         continue;
       }
       if (stage == 7) {
         var nums = line.split(" ");
         if (nums.length < 4) {
           console.log("tetra N",counter," line is bad! skipping to next line. bad text line=",line, "line number=",i+1 );
           continue;
         }
         // Я посмотрел ещё раз стандарт EnSight (http://vis.lbl.gov/NERSC/Software/ensight/doc/OnlineHelp/UM-C11.pdf) - там (с. 5) нумерация вершин с 1.
         for (var qq=0; qq<4; qq++) {
           var vak = parseInt(nums[qq])-1;
           indicesA[ qq+4*counter ] = vak;

           if (vak >= positionsA.length || vak < 0 || isNaN(vak)) {
             console.log( "tetra N",counter," (starting from 0) index N", qq," out of range or NaN! index value=",vak, "nums=",nums," positions len=", positionsA.length, 
                          "text line=",line, "line number=",i+1 );
             indicesA[ qq+4*counter ] = 0;
           }
         }
         counter++;
         if (counter >= numPositions)
         {
           stage = 8;
           // console.log("counter stopped, counter=",counter,"numPositions=",numPositions);
           
           indices = indicesA;
           
           //parent.setup( positionsA,indicesA );
           // finished!
           console.log("fin");
         }       
       } // stage 7

       } // for
       //debugger;

      } 
      ); // Lazy

  } // function
  
}