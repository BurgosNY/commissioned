package;


import openfl.display.Sprite;
import openfl.display.JointStyle;
import openfl.display.LineScaleMode;
import openfl.display.CapsStyle;
import openfl.display.Graphics;

class Main extends Sprite {

  var cosPi6 : Float;
  var sinPi6 : Float;
  
  public function new () {
    
    super ();

    cosPi6 = Math.cos(Math.PI / 6);
    sinPi6 = Math.sin(Math.PI / 6);

    graphics.beginFill(0);
    graphics.drawRect(0,0,stage.stageWidth, stage.stageHeight);

    var container = new Sprite();
    
    var outR = 70.0;

    for (a in 0...10)
      for (b in 0...10) {
	
	var s = new Sprite();
	
	
	s.graphics.lineStyle(4, 0xFFFFFF, 1.0, true,
			     LineScaleMode.NONE,
			     CapsStyle.NONE,
			     JointStyle.ROUND);
	
	
	
	transUnit( s.graphics, outR );
	
	s.x = (a+b) * (3*outR*cosPi6);
	s.y = (a * (outR + outR * sinPi6)) + (b * -1 * (outR + outR* sinPi6));
	
	container.addChild(s);
      }

    container.y = 250;
    container.x = -500;
    
    addChild(container);

  }

  private function upwardsEqTri ( g : Graphics, cx:Float, cy:Float, r:Float) {
    var pts = [{x:cx,y:cy-r},
	       {x: cx + r*cosPi6, y: cy + r*sinPi6},
	       {x: cx - r*cosPi6, y: cy + r*sinPi6}];

    drawTriangle( g, pts );
  }

  private function drawTriangle (g: Graphics, pts : Array<{x:Float,y:Float}>) {
    g.moveTo(pts[0].x, pts[0].y);
    g.lineTo(pts[1].x, pts[1].y);
    g.lineTo(pts[2].x, pts[2].y);
    g.lineTo(pts[0].x, pts[0].y);
    g.lineTo(pts[1].x, pts[1].y);

  }
  
  private function downwardsEqTri ( g:Graphics, cx:Float, cy:Float, r:Float) {
    var pts = [{x: cx, y: cy + r},
	       {x: cx + r*cosPi6, y: cy - r*sinPi6},
	       {x: cx - r*cosPi6, y: cy - r*sinPi6}];

    drawTriangle( g, pts );
  }
  

  private function transUnit (g: Graphics, r : Float) {
    var cs : Array<{x:Float,y:Float}>= [{x: 0,y: 0},
	      {x: r*cosPi6, y: -1 * r * sinPi6},
	      {x: 2*r*cosPi6, y: 0},
	      {x: 2*r*cosPi6, y: r},
	      {x: r*cosPi6, y: r * 1.5},
	      {x: 0, y: r  }];

    for (i in 0...6) if (i % 2 == 0) {
	upwardsEqTri(g,cs[i].x,cs[i].y,r);
	upwardsEqTri(g,cs[i].x,cs[i].y,r * (3.00 / 5.00));
	upwardsEqTri(g,cs[i].x,cs[i].y,r * (1.00 / 5.00));	  
      }	else {
	downwardsEqTri(g, cs[i].x, cs[i].y, r);
	downwardsEqTri(g, cs[i].x, cs[i].y, r * (3.00 / 5.00));
	downwardsEqTri(g, cs[i].x, cs[i].y, r * (1.00 / 5.00));	
      }

  }

}