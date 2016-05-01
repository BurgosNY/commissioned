package;


import openfl.display.Sprite;
import openfl.text.TextField;
import openfl.text.TextFormat;
import openfl.events.MouseEvent;

class Main extends Sprite {

  var errorLog : ErrorLog;
  var quiz : Array<QuizProblem>;
  var quizIndex : Int = 0;
  var nextButton : Sprite;
  
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
      removeChild(nextButton);
      addChild(nextButton);
    }
    if (quizIndex >= quiz.length) {
      removeChild(nextButton);
      generateErrorsReport();
    }
  }

  private function generateErrorsReport () {
    var rep : Array<String> = errorLog.generateReport();
    var repCont = new Sprite();
    var vdisp = 0;
    var format = new TextFormat();
    format.size = 25;
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
    nextButton = nb;
  }

  
  private function initQuiz () {
    quiz = [];
    quiz.push( new AdditionProblem( errorLog, [3321,4531,32] ));    
    quiz.push( new AdditionProblem( errorLog, [7543, 3235] ));
    quiz.push( new AdditionProblem( errorLog, [123,234,345] ));

    quiz.push( new MultipleChoice( errorLog,
    				   [{dispText: "Addition\nSubtraction\nMultiplication\nDivision",
    					 isCorrect: false,
    					 helpMessage: "Multiplication should be before addition",
    					 diagnosticMessage: "order of operations"},
    				     {dispText: "Parentheses\nExponents\nMultiplication\nDivision\nAddition\nSubtraction",
    				     	 isCorrect: true,
    				     	 helpMessage: "Correct!",
    				     	 diagnosticMessage: ""}
    				     ],
    				   "For this problem: 5 + 9 ✕ 3 + 7\nWhat is the correct order of operations?", false, true));

    quiz.push( new MultipleChoice( errorLog,
    				   [{dispText: "Addition",
    					 isCorrect: false,
    					 helpMessage: "Multiplication should be before addition",
    					 diagnosticMessage: "order of operations"},
    				     {dispText: "Subtraction",
    					 isCorrect: false,
    					 helpMessage: "No subtraction in this problem.",
    					 diagnosticMessage: "order of operations"},
    				     {dispText: "Division",
    					 isCorrect: false,
    					 helpMessage: "There is no division here",
    					 diagnosticMessage: "order of operations"},
    				     {dispText: "Multiplication",
    					 isCorrect: true,
    					 helpMessage: "Correct!",
    					 diagnosticMessage: "order of operations"},
    				     {dispText: "Parentheses",
    					 isCorrect: false,
    					 helpMessage: "No parentheses in this problem.",
    					 diagnosticMessage: "order of operations"},
    				     {dispText: "Exponents",
    					 isCorrect: false,
    					 helpMessage: "No exponents in this problem",
    					 diagnosticMessage: "order of operations"}
    				     ],
    				   "For this problem: 5 + 9 ✕ 3 + 7\nWhich operation comes first?"));

    quiz.push( new MultipleChoice( errorLog,
    				   [{dispText: "Addition",
    					 isCorrect: true,
    					 helpMessage: "Correct!",
    					 diagnosticMessage: "order of operations"},
    				     {dispText: "Subtraction",
    					 isCorrect: false,
    					 helpMessage: "No subtraction in this problem.",
    					 diagnosticMessage: "order of operations"},
    				     {dispText: "Division",
    					 isCorrect: false,
    					 helpMessage: "There is no division here",
    					 diagnosticMessage: "order of operations"},
    				     {dispText: "Multiplication",
    					 isCorrect: false,
    					 helpMessage: "No multiplication left to do.",
    					 diagnosticMessage: "order of operations"},
    				     {dispText: "Parentheses",
    					 isCorrect: false,
    					 helpMessage: "No parentheses in this problem.",
    					 diagnosticMessage: "order of operations"},
    				     {dispText: "Exponents",
    					 isCorrect: false,
    					 helpMessage: "No exponents in this problem",
    					 diagnosticMessage: "order of operations"}
    				     ],
    				   "For this problem: 5 + 9 ✕ 3 + 7 becomes 5 + 27 + 7\nWhat operation comes next?"));

        quiz.push( new MultipleChoice( errorLog,[
    				     {dispText: "Add left to right",
    					 isCorrect: true,
    					 helpMessage: "Correct.",
    					 diagnosticMessage: "order of operations"},
    				     {dispText: "Add largest numbers first",
    					 isCorrect: false,
    					 helpMessage: "Nope, you should add left to right",
    					 diagnosticMessage: "order of operations"}
				       
    				     ],
    				   "In 5 + 27 + 7, what is the rule \nfor order of addition?"));    

        quiz.push( new MultipleChoice( errorLog,[
    				     {dispText: "39",
    					 isCorrect: true,
    					 helpMessage: "Correct.",
    					 diagnosticMessage: "order of operations"},
    				     {dispText: "49",
    					 isCorrect: false,
    					 helpMessage: "Remeber order of operations, multiplication comes first",
    					 diagnosticMessage: "order of operations"},
    				     {dispText: "95",
    					 isCorrect: false,
    					 helpMessage: "Nope, you should add left to right",
    					 diagnosticMessage: "remember order of operations, multiplication comes first"}
    				     ],
    				   "So what is 5 + 9 ✕ 3 + 7 ?"));

	quiz.push( new MultipleChoice( errorLog,
				       [{dispText: "Yes", isCorrect: false, helpMessage: "the denominator is on the bottom of a fraction",
					     diagnosticMessage: "fractions error"},
					 {dispText: "No", isCorrect: true, helpMessage: "correct!", diagnosticMessage:""}],
				       "assets/fractions1.png", true));

	quiz.push( new MultipleChoice( errorLog,
				       [{dispText: "find the greatest common multiple", isCorrect: false, helpMessage: "try again",
					     diagnosticMessage: "fractions error"},
					{dispText: "find the least common denominator", isCorrect: true, helpMessage: "Correct",
					     diagnosticMessage: ""},
					{dispText: "add the numerators and denominators together", isCorrect: false, helpMessage: "denominators must be the same",
					     diagnosticMessage: "fractions error"},
					 ],
				       "assets/fractions2.png", true));

	quiz.push( new MultipleChoice( errorLog,
				       [{dispText: "12 is the LCD", isCorrect: true, helpMessage: "Correct",
					     diagnosticMessage: ""},
					 {dispText: "2 is the LCD", isCorrect: false, helpMessage: "the LCD is the least common multiple of the denominators",
					     diagnosticMessage: "fractions error"}
					 ],
				       "assets/fractions3.png", true));

	quiz.push( new MultipleChoice( errorLog,
				       [{dispText: "108°", isCorrect: false, helpMessage: "this is not an equilateral pentagon",
					     diagnosticMessage: "polygon facts error"},
					 {dispText: "95°", isCorrect: false, helpMessage: "these angles are not supplementary",
					     diagnosticMessage: "polygon facts error"},
					 {dispText: "163°", isCorrect: true, helpMessage: "Correct",
					     diagnosticMessage: ""}
					 ],
				       "assets/geom1.png", true, true));

	quiz.push( new MultipleChoice( errorLog,
				       [{dispText: "80°", isCorrect: false, helpMessage: "corresponding angels are congruent",
					     diagnosticMessage: "parallel lines error"},
					 {dispText: "100°", isCorrect: true, helpMessage: "Correct",
					     diagnosticMessage: ""},
					 {dispText: "110°", isCorrect: false, helpMessage: "corresponding angels are congruent",
					     diagnosticMessage: "parallel lines error"},
					 {dispText: "140°", isCorrect: false, helpMessage: "corresponding angels are congruent",
					     diagnosticMessage: "parallel lines error"}
					 ],
				       "assets/angles1.png", true, true));


    //    Util.randomize( quiz );
    
    addChild(quiz[0]);
    centerInStage(quiz[0]);
  }
	
  
}