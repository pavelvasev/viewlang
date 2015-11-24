Item {

  signal positionChanged( object event );
  signal clicked( object event );
  signal doubleClicked( object event );
  
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