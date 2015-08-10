Item {
  property var source: parent

  property var input: source.output
  property var mult: 1
  property var div: null
  
  property var output: div ? divArray( input,div ) : multArray( input, mult );

  function multArray(arr,coef) {
    return arr.map( function(v) { 
      if (v.slice) // array
        return multArray( v,coef );
      else // others
        return v*coef; 
    });
  } 

  function divArray(arr,coef) {
    return arr.map( function(v) { 
      if (v.slice) // array
        return multArray( v,coef );
      else // others
        return v/coef; 
    });
  }  
}