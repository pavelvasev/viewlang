Item {
  property var input: parent.output
  property var output: flattenArrayOfArrays( input )
  
  // медленное..
  // http://stackoverflow.com/a/15030117
  // The previously posted solution actually didn't produce the correct result on nested
  // arrays.  This simpler solution does.
  function flatten(arr) {
  return arr.reduce(function (flat, toFlatten) {
    return flat.concat(Array.isArray(toFlatten) ? flatten(toFlatten) : toFlatten);
  }, []);
  }  

  function flattenArrayOfArrays(a, r){
    if(!r){ r = []}
    for(var i=0; i<a.length; i++){
        if(a[i].constructor == Array){
            flattenArrayOfArrays(a[i], r);
        }else{
            r.push( a[i] );
        }
    }
    return r;
  }
  
}