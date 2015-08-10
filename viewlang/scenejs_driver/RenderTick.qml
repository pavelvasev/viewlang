Item {

  signal action(real time, real ms);

  Component.onCompleted: {

    scene.on("tick", function() { 
        action( 0,0.0001 );
    } );

  }

}