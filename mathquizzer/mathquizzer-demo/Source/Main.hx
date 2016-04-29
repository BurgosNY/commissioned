package;


import openfl.display.Sprite;


class Main extends Sprite {

  var errorLog : ErrorLog;
  var quiz : Array<QuizProblem>;
  
  public function new () {
    super ();
    errorLog = new ErrorLog();
    // splashScreen();
    initQuiz();
    
  }

  private function initQuiz () {
    quiz = [];
    quiz.push( new AdditionProblem( errorLog, [123,234,345] ) );
    addChild(quiz[0]);
  }
	
  
}