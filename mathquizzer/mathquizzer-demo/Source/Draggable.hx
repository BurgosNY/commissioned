package;

import openfl.display.Sprite;
import openfl.events.MouseEvent;

using Lambda;

class Draggable extends Sprite {

  var dragging : Bool = false;
  var dropSpots : Array<Sprite>;
  var currentlyOver : Sprite;

  var overDropSpot : Sprite -> Sprite -> Void;
  var offDropSpot :  Sprite -> Sprite -> Void;
  var uponDrop :  Sprite -> Sprite -> Void;  
  
  public function new ( overDs : Sprite -> Sprite -> Void , 
			offDs : Sprite -> Sprite -> Void ,
			onDrop : Sprite -> Sprite -> Void ) {
    super();

    dropSpots = [];
    
    overDropSpot = overDs;
    offDropSpot = offDs;
    uponDrop = onDrop;
    
    addEventListener(MouseEvent.MOUSE_DOWN, function (e) {
	this.startDrag();
	this.dragging = true;
      });

    addEventListener(MouseEvent.MOUSE_MOVE, function (e) {
	// only run anything if currently dragging
	if (this.dragging) {

	  if (currentlyOver == null) {

	    // check whether we're over a dropzone
	    currentlyOver = dropSpots.find( this.hitTestObject );

	    // if we are, run the callback overDropSpot
	    if (currentlyOver != null) overDropSpot( this, currentlyOver );

	    // we were currently over a dropzone, but we may not be now
	  } else if ( !this.hitTestObject( currentlyOver ) ) {

	    // if we're not, run the offDropSpot callback
	    offDropSpot( this, currentlyOver );

	    // and set currentlyOver to null
	    currentlyOver = null;
	  }
	}
      });

    addEventListener(MouseEvent.MOUSE_UP, function (e) {
	stopDrag();
	dragging = false;
	uponDrop( this, currentlyOver ); // NB: currentlyOver may be null!
      });
  }


  public function registerDropSpot (s : Sprite) {
    dropSpots.push( s );
  }

  public function removeDropSpot (s : Sprite) {
    dropSpots.remove( s );
  }

  public function forceDragging () {
    this.startDrag();
    this.dragging = true;
  }
  
}