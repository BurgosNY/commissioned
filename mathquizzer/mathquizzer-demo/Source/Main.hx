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
    quiz.push( new AdditionProblem( errorLog, [1,2,3] ) );
    addChild(quiz[0]);
  }
	
  
}