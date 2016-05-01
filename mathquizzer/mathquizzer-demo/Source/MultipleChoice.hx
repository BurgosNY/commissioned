
package;

import openfl.display.Sprite;
import haxe.ds.Option;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.events.MouseEvent;

using Lambda;

typedef ChoiceSpec = {
 dispText: String,
 isCorrect: Bool,
 helpMessage: String,
 diagnosticMessage: String
};

typedef Choices = Array<ChoiceSpec>;

class MultipleChoice extends QuizProblem {

  var problemPrompt : Sprite;
  var choices : Choices;
  var choiceList : Sprite;
    
  public function new (el : ErrorLog, choices: Choices,
		       prompt : String, ?filename = false, ?horiz = false) {

    super( el );
    this.choices = choices;
    problemPrompt = new Sprite();

    if  (filename) buildImagePrompt( prompt);
    else  buildTextPrompt( prompt);      

    addChild( problemPrompt );
    
    buildChoiceList(horiz);
    
  }

  private function buildImagePrompt (prompt : String) {
    openfl.Assets.loadBitmapData(prompt).onComplete(function (bmpdat) {
	var bmp = new openfl.display.Bitmap( bmpdat);
	problemPrompt.addChild(bmp);
      });
  }

  private function buildTextPrompt (prompt : String) {
    var format = new TextFormat();
    format.size = 40;
    format.color = 0;

    var tf = new TextField();
    tf.defaultTextFormat = format;
    tf.selectable = false;
    tf.autoSize = openfl.text.TextFieldAutoSize.CENTER;
    tf.text = prompt;

    problemPrompt.addChild( tf );
   
  }

  private function buildChoiceList (?horiz = false) {
    choiceList = new Sprite();

    var format = new TextFormat();
    format.size = 20;
    format.color = 0;

    var buttons = [];

    var textElements = [];
    for (spec in choices) {
      var tf = new TextField();
      tf.autoSize = openfl.text.TextFieldAutoSize.LEFT;
      tf.multiline = true;
      tf.defaultTextFormat = format;
      tf.text = spec.dispText;
      textElements.push(tf);
    }

    var maxWidth = 0.0;
    var maxHeight = 0.0;

    for (tf in textElements) {
      maxWidth = Math.max(tf.width, maxWidth);
      maxHeight = Math.max(tf.height, maxHeight);
    }
    
    
    var choiceButton = function (i : Int) {
      var button = new Sprite();
      buttons.push( button );
      
      var beenClicked = false;
      var isClicked = false;
      
      var spec = choices[i];
      // var tf = new TextField();
      // tf.autoSize = openfl.text.TextFieldAutoSize.LEFT;
      // tf.multiline = true;
      // tf.defaultTextFormat = format;
      // tf.text = spec.dispText;

      // button.width = tf.width;
      // button.height = tf.height;

      button.graphics.beginFill(0xffffff);
      //      button.graphics.drawRect( 0, 0, button.width, button.height);
      button.graphics.drawRect( 0, 0, maxWidth, maxHeight);
      button.graphics.endFill();
      
      
      button.addChild( textElements[i] );
      
      if (i > 0) 
      	for (j in 0...i)
      	  if (horiz) {
      	    button.x += (maxWidth + 4);
      	  } else {
      	    button.y += (maxHeight + 4);
      	  }
      

      
      button.addEventListener( MouseEvent.MOUSE_OVER, function (e) {
	  if (!isClicked) {
	    button.graphics.beginFill(0xdddddd); // MAGIC NUMBER!!:(
	    button.graphics.drawRect( 0, 0, maxWidth, maxHeight);
	    //	    button.graphics.drawRect(0,0,button.width, button.height);
	    button.graphics.endFill();
	  }
	});


      button.addEventListener( MouseEvent.MOUSE_OUT, function (e) {
	  if (!isClicked) {
	    button.graphics.beginFill(0xffffff); // MAGIC NUMBER :(
	    button.graphics.drawRect( 0, 0, maxWidth, maxHeight);
	    //	    button.graphics.drawRect(0,0,button.width, button.height);
	    button.graphics.endFill();
	  }
	});
      
      button.addEventListener( MouseEvent.CLICK, function (e) {
	  isClicked = !isClicked;
	  if (spec.isCorrect) {
	    isClicked = true;	// don't let unclicking of correct answers.
	    button.graphics.beginFill(0xAAFFAA);
	    button.graphics.drawRect( 0, 0, maxWidth, maxHeight);
	    //	    button.graphics.drawRect(0,0,button.width,button.height);
	    button.graphics.endFill();
	    trace( spec.helpMessage);
	  } else if (!beenClicked) {
	    trace( spec.helpMessage );
	    this.errorLog.report( spec.diagnosticMessage );
	  }

	  beenClicked = true;
	});

      return button;
    };

    for (i in 0...(this.choices.length)) {
      var b = choiceButton(i);
      choiceList.addChild( b );
    }
    
    choiceList.y = problemPrompt.height + 10;
    addChild( choiceList );    
    
  }
  
  
}