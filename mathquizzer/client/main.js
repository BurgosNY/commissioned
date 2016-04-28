import { Template } from 'meteor/templating';
import { ReactiveVar } from 'meteor/reactive-var';

import './main.html';

const padLeft = function (s,f,w) {
    var x = s;
    while (x.length < w) {
	x = f + x;
    }
    return x;
}


const tooltipName = function (n) {
    return "tooltip_for_problem_" + n;
};

const rational = function (n,d) {
    return {numerator:n, denominator:d};
};

const integerToDigitStrings = function (n, padTo) {
    padTo = padTo || 0;
    return padLeft(n+""," ",padTo).split("");
};

const additionProblem = function (id, summands, tooltipText) {
    let tooltip = tooltipText || "This is the default suggestion text for addition problems.";
    
    let stringSummands = summands.map((s) => {return (s+"");});

    let maxlength = 0;
    stringSummands.forEach((s) => {
	maxlength = Math.max(maxlength, s.length);
    });

    let digitSummands = stringSummands.map((s) => {
	return padLeft(s," ", maxlength+1).split("");
    });

    // for display purposes, add a +
    digitSummands[digitSummands.length -1][0] = "+";
    
    let answer = summands.reduce((a,b) => {return a+b;});
    
    return {id: id,
	    type: "simple addition",
	    summands: digitSummands,
	    answer: [padLeft(answer+""," ",maxlength+1).split("")],
	    tooltip: tooltip
	   };
};


const multiplicationProblem = function (id, f1,f2, tooltipText) {
    let tooltip = tooltipText || "This is the default text for multiplication problems";

    let digitAnswer = integerToDigitStrings(f1*f2);
    let padTo = digitAnswer.length;
    
    let steps = [];
    let f2String = (f2+"");
    let rightPad = "";
    
    for (let i in f2String) {
	let d = Number(f2String[f2String.length - i - 1]);
	let step = integerToDigitStrings( (f1*d) + rightPad, padTo);
	rightPad += " ";
	steps.push(step);
    }
    console.log(steps);
    let digitFactors = [integerToDigitStrings(f1, padTo),
			integerToDigitStrings(f2, padTo)];
    digitFactors[digitFactors.length -1][0] = "✕";

    steps.push(digitAnswer);
    console.log(steps);
    return {id: id,
	    type: "simple multiplication",
	    factors: digitFactors,
	    answer: steps,
	    tooltip: tooltip
	   };
};

const exampleProblems = [
    additionProblem(0, [3749, 7392, 2027]),
    additionProblem(1, [174, 2392, 225], "Here is some custom text"),
    multiplicationProblem(2, 836, 268),
    multiplicationProblem(3, 3892, 74, "Or put any tip you like here")
];

Template.demoQuiz.onCreated(function () {
    Session.set("currentProblem", 0);
});

Template.demoQuiz.helpers({

    currentProblem () {
	let prob = Session.get("currentProblem");
	return exampleProblems[prob];
    }


});

Template.showProblem.helpers({

    isSimpleAddition (doc) {
	return doc.type === "simple addition";
    },

    isSimpleMultiplication (doc) {
	return doc.type === "simple multiplication";
    },
    
    tooltipOn (id) {
	return !!Session.get(tooltipName(id));
    }

    
});

Template.demoQuiz.events({
    'click #nextButton' : (event) => {
	Session.set("currentProblem", Session.get("currentProblem")+1);
	var inputs = $('input');
	for (var i =0; i<inputs.length;i+=1) {
	    inputs[i].value="";
	}

	$('input').attr('class', 'cell neutral');
    }
})

Template.simpleAddition.helpers({
    answerIndexes (answer) {
	let idx = [];
	for (let i = 0; i<answer[0].length; i+=1) idx.push(i);
	return idx;
    }
});


Template.simpleMultiplication.helpers({
    stepsIndexes (answer) {
	let idx = [];
	for (let i = 0; i<answer.length; i+=1) idx.push(i);
	return idx;
    },
    
    answerIndexes (answer, step) {
	let idx = [];
	for (let i = 0; i<answer[step].length; i += 1) idx.push(i);
	return idx;
    }
});

// change lookupAnswer to search for prob with correct id rather than
// by array index
const lookupAnswer = function (prob, step, idx) {
    return exampleProblems[prob].answer[step][idx];
};

Template.answerRow.helpers({
    hasAnswer (id,step,idx) {
	let ans = lookupAnswer(Number(id), Number(step), Number(idx));
	return !(ans === " ");
    }
})

Template.answerRow.events({
    'keyup': (e) => {
	let val = e.target.value;
	let keys = e.target.id.split("_");
	let prob = Number(keys[1]);
	let step = Number(keys[2]);
	let idx = Number(keys[3]);
	
	let rightAnswer = lookupAnswer(prob, step, idx);
	if (rightAnswer == val) {
	    $(e.target).attr("class", "cell correct");
	    let prev = $(e.target.parentNode).prev().children()[0];
	    $(prev).focus();
	} else {
	    $(e.target).attr("class", "cell incorrect");
	    Session.set(tooltipName(prob), true);
	}
    }
});
