MouseArea {

/*
  signal positionChanged( var mouse );
  signal clicked( var mouse );
*/  
  signal doubleClicked( object mouse );

  
  Component.onCompleted: {
    jQuery(driverDomElement).mousemove( function(event) {
      positionChanged(event);
    } );
    jQuery(driverDomElement).click( function(event) {
      clicked(event);
    } );    
    jQuery(driverDomElement).dblclick( function(event) {
      doubleClicked(event);
    } );        
  }

}