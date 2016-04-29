package;

import openfl.display.Sprite;
import haxe.ds.Option;

using Lambda;

typedef DropSpotInfo = {
 expects : Option<Int>,
 error : String
};

class AdditionProblem extends QuizProblem {

  private static var DRAGGABLE_HEIGHT = 80;
  private static var DRAGGABLE_WIDTH = 60;

  private static var DROPSPOT_HEIGHT = 90;
  private static var DROPSPOT_WIDTH = 70;

  private static var OVER_DROP_SPOT_COLOR = 0x777777;
  private static var OFF_DROP_SPOT_COLOR = 0xFFFFFF;
  private static var CORRECT_DROP_SPOT_COLOR = 0xDDEADD;
  private static var INCORRECT_DROP_SPOT_COLOR = 0xEADDDD;
  
  var checkMap : Map<Sprite, DropSpotInfo>;
  
  public function new (el : ErrorLog, summands : Array<Int>) {
    super(el);
    checkMap = new Map();    

    graphics.lineStyle(1.0, 0);
    graphics.drawRect(0,0,500,500);
    
    initNumberFactory();

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
    
    var numberFactoryWidget1 = new NumberFactory(1, this, overds, offds, ond(1),
						 DRAGGABLE_WIDTH,
						 DRAGGABLE_HEIGHT);
    
    addChild( numberFactoryWidget1 );
    // numberFactoryWidget.container = this;
    // numberFactoryWidget.overDropspot = ovds;
    // numberFactoryWidget.offDropspot = ofds;
    // numberFactoryWidget.onDropMaker = ond;
  }
  
}