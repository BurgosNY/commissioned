package;

import openfl.display.Sprite;
import haxe.ds.Option;
import openfl.text.TextField;
import openfl.text.TextFormat;



using Lambda;

typedef DropSpotInfo = {
 expects : Option<Int>,
 error : String
};

class AdditionProblem extends QuizProblem {

  private static var DRAGGABLE_HEIGHT = 60;
  private static var DRAGGABLE_WIDTH = 40;

  private static var DROPSPOT_HEIGHT = 70;
  private static var DROPSPOT_WIDTH = 50;

  private static var OVER_DROP_SPOT_COLOR = 0x777777;
  private static var OFF_DROP_SPOT_COLOR = 0xFFFFFF;
  private static var CORRECT_DROP_SPOT_COLOR = 0xDDEADD;
  private static var INCORRECT_DROP_SPOT_COLOR = 0xEADDDD;
  
  var checkMap : Map<Sprite, DropSpotInfo>;
  
  public function new (el : ErrorLog, summands : Array<Int>) {
    super(el);
    checkMap = new Map();    

    graphics.lineStyle(1.0, 0);
    graphics.drawRect(0,0,10 * DRAGGABLE_WIDTH, 500);
    
    initNumberFactory();

    initDropSpots(summands);
  }


  private function initDropSpots (summands : Array<Int>) {
    var widestNumber = 0;

    var stringSummands = summands.map(function (s) {
	var ds = Util.digits(s).map(Std.string);
	widestNumber = Std.int(Math.max(widestNumber, ds.length));
	return ds;
      });

    for (ss in stringSummands) Util.padLeft( ss, "", widestNumber + 1);

    stringSummands[stringSummands.length - 1][0] = "+";
    
    var digitFormat = new TextFormat();
    digitFormat.size = 40;
    digitFormat.color = 0;

    var verticalDisplacement = DRAGGABLE_HEIGHT * 2;
    
    var addDigitDisplay = function (i, j) {
      var ds = new Sprite();
      ds.graphics.beginFill(0xF0F0F0);
      ds.graphics.drawRect( 0, 0, DROPSPOT_WIDTH, DROPSPOT_HEIGHT);
      ds.graphics.endFill();
      ds.x = DROPSPOT_WIDTH * j;
      ds.y = DROPSPOT_HEIGHT * i + verticalDisplacement;

      var dstxt = new TextField();
      dstxt.defaultTextFormat = digitFormat;
      dstxt.text = stringSummands[i][j];

      ds.addChild(dstxt);
      dstxt.x = (ds.width - dstxt.width) / 2;
      dstxt.y = (ds.height - dstxt.height) / 2;
      
      addChild(ds);
    };

    trace(stringSummands);

    for (i in 0...(stringSummands.length))
      for (j in 0...(stringSummands[i].length)) {
	addDigitDisplay(i, j);
      }
	

  }

  private function initNumberFactory () {

    var fillDsWith = function (ds : Sprite, color) {
      ds.graphics.clear();
      ds.graphics.beginFill( color );
      ds.graphics.drawRect(0,0,DROPSPOT_WIDTH, DROPSPOT_HEIGHT);
      ds.graphics.endFill();
    }
    
    var overds = function (drg, ds) {
      fillDsWith( ds, OVER_DROP_SPOT_COLOR);
    };

    var offds = function (drg, ds) {
      fillDsWith( ds, OFF_DROP_SPOT_COLOR);
    };

    var ond = function (i : Int) {
      return function (drg : Sprite, ds : Sprite) {
	if (ds == null) {

	  drg.parent.removeChild( drg );

	} else {

	  var info = checkMap.get( ds );

	  if (info != null) {

	    switch (info.expects) {

	    case None: {
	      this.errorLog.report( info.error );
	      fillDsWith( ds, INCORRECT_DROP_SPOT_COLOR);
	    }

	    case Some(j): if (i != j) {
		this.errorLog.report( info.error );
		fillDsWith( ds, INCORRECT_DROP_SPOT_COLOR);
	      } else {
		fillDsWith( ds, CORRECT_DROP_SPOT_COLOR );
	      }
	    }
	  }
	}
      };
    };

    for (i in 0...10) {
      var nf = new NumberFactory(i, this, overds, offds, ond(i),
				 DRAGGABLE_WIDTH,
				 DRAGGABLE_HEIGHT);

      nf.x = i * DRAGGABLE_WIDTH;
      addChild( nf );

    }
    
  }
  
}