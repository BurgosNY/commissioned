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
  private static var CORRECT_DROP_SPOT_COLOR = 0xAAFFAA;
  private static var INCORRECT_DROP_SPOT_COLOR = 0xFFAAAA;
  
  var checkMap : Map<Sprite, DropSpotInfo>;
  var carryover : Array<Int>;
  var answer : Array<Int>;

  
  public function new (el : ErrorLog, summands : Array<Int>) {
    super(el);
    checkMap = new Map();    

    graphics.lineStyle(1.0, 0);
    graphics.drawRect(0,0,10 * DRAGGABLE_WIDTH, 500);

    initSolution(summands);
    initProblemDisplay(summands);

    initNumberFactory();	// must com last, relies on checkMap being filled

  }

  private function initSolution (summands : Array<Int>) {
    var widestNumber = 0;

    var alldigits = summands.map(function (n) {
	var d = Util.digits(n);
	widestNumber = Std.int(Math.max(widestNumber, d.length));
	return d;
      });

    widestNumber += 1;
    
    this.carryover = Util.padLeft([],0, widestNumber);
    this.answer = Util.padLeft([],0,widestNumber);

    for (d in alldigits) Util.padLeft( d, 0, widestNumber);

    for (i in 0...widestNumber) {
      var digitSum = carryover[(widestNumber - 1) - i];
      for (j in 0...(alldigits.length))
	digitSum += alldigits[j][(widestNumber - 1) - i];

      this.carryover[(widestNumber-1) - (i+1)] = Std.int(Math.floor(digitSum/10));
      this.answer[(widestNumber - 1) - i] = digitSum % 10;
    }

  }


  
  private function initProblemDisplay (summands : Array<Int>) {
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

    var verticalDisplacement = DROPSPOT_HEIGHT * 2;
    
    var addDigitDisplay = function (i, j) {
      var ds = new Sprite();
      ds.graphics.beginFill(OFF_DROP_SPOT_COLOR);
      ds.graphics.drawRect( 0, 0, DROPSPOT_WIDTH, DROPSPOT_HEIGHT);
      ds.graphics.endFill();
      ds.x = DROPSPOT_WIDTH * j;
      ds.y = DROPSPOT_HEIGHT * i + verticalDisplacement;

      var dstxt = new TextField();
      dstxt.width = ds.width;
      dstxt.height = ds.height;
      dstxt.defaultTextFormat = digitFormat;
      dstxt.text = stringSummands[i][j];

      ds.addChild(dstxt);
      dstxt.x = (ds.width - dstxt.width) / 2;
      dstxt.y = (ds.height - dstxt.height) / 2;
      
      addChild(ds);
    };

    for (i in 0...(stringSummands.length))
      for (j in 0...(stringSummands[i].length)) {
	addDigitDisplay(i, j);
      }

    var initDropSpot = function (ex : Int, er: String, h: Int, v : Float) {
      
      var ds = new Sprite();
      //      ds.graphics.lineStyle(1,0);
      ds.graphics.beginFill(OFF_DROP_SPOT_COLOR);
      ds.graphics.drawRect(0,0,DROPSPOT_WIDTH, DROPSPOT_HEIGHT);
      ds.graphics.endFill();

      ds.x = h*DROPSPOT_WIDTH;
      ds.y = v;

      checkMap.set(ds, {expects: Some(ex), error: er});

      addChild(ds);
      
    };
    
    for (i in 0...(this.carryover.length))
      initDropSpot(this.carryover[i], "carryover error", i, DROPSPOT_HEIGHT);
    
    for (i in 0...(this.answer.length))
      initDropSpot(this.answer[i], "summ error",i, 
		   DROPSPOT_HEIGHT * (summands.length + 2) + 20);

    
    graphics.lineStyle(4,0);
    graphics.moveTo(0, DROPSPOT_HEIGHT * (summands.length + 2) + 10);
    graphics.lineTo((widestNumber +1) * DROPSPOT_WIDTH, DROPSPOT_HEIGHT * (summands.length + 2) + 10);
		    
    
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

	  drg.x = (ds.x + (ds.width - drg.width) / 2);
	  drg.y = (ds.y + (ds.height - drg.height) / 2);
	  
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

    var dropspots = [];
    for (ds in checkMap.keys()) dropspots.push(ds);
    
    for (i in 0...10) {
      var nf = new NumberFactory(dropspots, i, this,
				 overds, offds, ond(i),
				 DRAGGABLE_WIDTH,
				 DRAGGABLE_HEIGHT);

      nf.x = i * DRAGGABLE_WIDTH;
      addChild( nf );

    }
    
  }
  
}