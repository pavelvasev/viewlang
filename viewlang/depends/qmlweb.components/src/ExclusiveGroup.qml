Item {
  id: obj

  property var items: []
  property var signals: []

  property var current 

  function bindCheckable(object) {
    if (items.indexOf(object) < 0) {
      items.push( object );

      var f = function( val ) {
        if (val) activate(object);
      }
      signals.push( f );

      object["checkedChanged"].connect( obj,f );

      f( object.checked );
    }
  }

  function unbindCheckable(object) {
    var i = items.indexOf(object);
    if (i >= 0) {
      items.slice( i,1 );

      var f = signals[i];
      signals.slice( i,1 );
      object["checkedChanged"].disconnect( obj,f );
    }
  }

  ///
  function activate(object) {
    for (var i=0; i<items.length; i++)
        items[i].checked = (items[i] === object);
    current = object;    
    // console.log("exclusive group activated object ",current.text );
  }

  property var name: "QmlExclusiveGroup"+Math.random();
}