package;

import openfl.display.Sprite;
import openfl.events.MouseEvent;
import openfl.text.TextField;
import openfl.text.TextFormat;


class NumberFactory extends Sprite {

  public var container : Sprite; // usually the parent, but allows
				 // reference before this is added to
				 // parent.
  // public var overDropspot : Sprite -> Sprite -> Void;
  // public var offDropspot : Sprite -> Sprite -> Void;
  // public var onDropMaker : Int -> (Sprite -> Sprite -> Void);
  
  public function new (i : Int, container, overds, offds, ondrop, w, h) {
    super();

    var format = new TextFormat();
    format.size = 40;
    format.color = 0;

    graphics.lineStyle(2.0,0);
    graphics.drawRect(0,0,w,h);
    var numtext = new TextField();
    numtext.selectable = false;
    numtext.defaultTextFormat = format;
    numtext.text = Std.string( i );
    addChild( numtext );
    numtext.x = (this.width - numtext.width) / 2;
    
    addEventListener(MouseEvent.MOUSE_DOWN, function (e) {
	var num = new Draggable( overds, offds, ondrop );
	num.graphics.lineStyle(2.0, 0);
	num.graphics.drawRect(0,0, w, h);
	var tf = new TextField();
	tf.selectable = false;
	tf.defaultTextFormat = format;
	tf.text = Std.string(i);
	num.addChild(tf);
	tf.x = (num.width - tf.width) / 2;

	num.x = this.x;
	num.y = this.y;
	container.addChild( num );
	
	num.forceDragging();
      });

    
    
  }

}