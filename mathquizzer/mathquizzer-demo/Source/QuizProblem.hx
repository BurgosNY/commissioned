package;

import openfl.display.Sprite;

// enum ProblemType {
//   AdditionProblemType( prob : AdditionProblem);
// }

class QuizProblem extends Sprite {

  public var errorLog : ErrorLog;
  
  public function new (el : ErrorLog) {
    super();
    errorLog = el;
  }
  
}