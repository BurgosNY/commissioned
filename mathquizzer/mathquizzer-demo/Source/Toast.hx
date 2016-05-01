
import openfl.display.Sprite;
import openfl.text.TextField;
import openfl.text.TextFormat;
import motion.Actuate;

class Toast extends Sprite {

  public function new (t : String, par : openfl.display.DisplayObjectContainer) {
    
    super();

    var format = new TextFormat();
    format.size = 30;
    format.color = 0xFFFFFF;

    var tf = new TextField();
    tf.defaultTextFormat = format;
    tf.autoSize = openfl.text.TextFieldAutoSize.LEFT;
    tf.multiline = true;
    tf.selectable = false;
    tf.wordWrap = true;
    tf.width = par.width * 0.75;
    tf.height = par.height * 0.75;
    tf.text = t;

    graphics.beginFill(0x333333);
    graphics.drawRect(0,0,par.width * 0.75, par.height * 0.75);

    this.x = par.width / 4;
    this.y = par.width / 4;
        
    addChild(tf);

    
    par.addChild(this);

    this.addEventListener(openfl.events.MouseEvent.CLICK, function (e) {
	Actuate.tween( this, 1.6, {alpha : 0}).onComplete(function () {
	    par.removeChild(this);
	  });
      });
    
    Actuate.tween( this, 1.6, {alpha : 0}).delay(4).onComplete(function () {
	par.removeChild(this);
      });
    
  }

}