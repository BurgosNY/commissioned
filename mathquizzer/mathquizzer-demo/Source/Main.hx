package;


import openfl.display.Sprite;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.events.MouseEvent;

class Main extends Sprite {

  var errorLog : ErrorLog;
  var quiz : Array<QuizProblem>;
  var quizIndex : Int = 0;
  var nxtbutton : Sprite;
  
  public function new () {
    super ();
    errorLog = new ErrorLog();
    // splashScreen();
    initQuiz();
    addNextButton();
  }

  private function loadProblem () {
    if (quizIndex > 0) removeChild(quiz[quizIndex - 1]);
    if (quizIndex < quiz.length) {
      addChild(quiz[quizIndex]);
      centerInStage(quiz[quizIndex]);
    }
    if (quizIndex >= quiz.length) {
      removeChild(nxtbutton);
      generateErrorsReport();
    }
  }

  private function generateErrorsReport () {
    var rep : Array<String> = errorLog.generateReport();
    var repCont = new Sprite();
    var vdisp = 0;
    var format = new TextFormat();
    format.size = 35;
    format.color = 0;
    
    for (txt in rep) {
      var field = new TextField();
      field.width = 500;
      field.defaultTextFormat = format;
      field.text = txt;
      field.y = vdisp;
      vdisp += 55;
      repCont.addChild(field);
    }

    centerInStage(repCont);
    addChild(repCont);
  }
  
  private function centerInStage( s : Sprite) {
    s.x = (stage.stageWidth - s.width) / 2;
    s.y = (stage.stageHeight - s.height) / 2;

  }
  
  private function addNextButton () {

    var nb = new Sprite();
    nb.buttonMode = true;
    nb.graphics.beginFill(0x454545);
    nb.graphics.drawRect(0,0,80,46);
    nb.graphics.endFill();

    nb.addEventListener(MouseEvent.CLICK, function (e) {
	quizIndex += 1;
	loadProblem();
      });


    var format = new TextFormat();
    format.size = 28;
    format.color = 0;

    var txt = new TextField();
    txt.selectable = false;
    txt.defaultTextFormat = format;
    txt.text = "next";
    txt.width = nb.width;
    txt.height = nb.height;    
    
    nb.addChild( txt);

    nb.x = stage.stageWidth - nb.width - 15;
    nb.y = stage.stageHeight / 2;
    
    addChild(nb);
    nxtbutton = nb;
  }

  
  private function initQuiz () {
    quiz = [];
    quiz.push( new AdditionProblem( errorLog, [3321,4531,32] ));    
    quiz.push( new AdditionProblem( errorLog, [7543, 3235] ));
    quiz.push( new AdditionProblem( errorLog, [123,234,345] ));

    addChild(quiz[0]);
    centerInStage(quiz[0]);
  }
	
  
}