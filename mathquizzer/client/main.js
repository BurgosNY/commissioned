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

const additionProblem = function (id, summands, tooltipText) {
    let tooltip = tooltip || "Did you remember to carry between columns?";
    
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
	    answer: padLeft(answer+""," ",maxlength+1).split(""),
	    tooltip: tooltip
	   };
};


const multiplicationProblem = function (id, factors, tooltipText) {
    let tooltip = tooltipText || "Did you remember to shift while multiplying the digits in the second factor by the first factor?";
    
    let stringFactors = factors.map((s) => {return (s+"");});

    let answer = factors.reduce((a,b) => {return a*b;});
    let digitAnswer = (answer+"").split("");

    let digitFactors = stringFactors.map((s) => {
	return padLeft(s, " ", digitAnswer.length).split("");
    });
    
    digitFactors[digitFactors.length -1][0] = "✕";

    return {id: id,
	    type: "simple multiplication",
	    factors: digitFactors,
	    answer: digitAnswer,
	    tooltip: tooltip
	   };
};

const exampleProblems = [
    additionProblem(0, [3749, 7392, 2027]),
    additionProblem(1, [174, 2392, 225]),
    multiplicationProblem(2, [836, 268]),
    multiplicationProblem(3, [3892, 74])
];

Template.demoQuiz.onCreated(function () {
    Session.set("currentProblem", 0);
});

Template.demoQuiz.helpers({

    currentProblem () {
	let prob = Session.get("currentProblem");
	return exampleProblems[prob];
    },

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
	console.log("fuck yealllll");
	Session.set("currentProblem", Session.get("currentProblem")+1);
    }
})

Template.simpleAddition.helpers({
    answerIndexes (answer) {
	let idx = [];
	for (let i = 0; i<answer.length; i+=1) idx.push(i);
	return idx;
    }
});


Template.simpleMultiplication.helpers({
    answerIndexes (answer) {
	let idx = [];
	for (let i = 0; i<answer.length; i+=1) idx.push(i);
	return idx;
    }
});

// change lookupAnswer to search for prob with correct id rather than
// by array index
const lookupAnswer = function (prob, idx) {
    return exampleProblems[prob].answer[idx];
};



Template.answerRow.events({
    'keyup': (e) => {
	let val = e.target.value;
	let prob = Number(e.target.parentNode.parentNode.id.split("_")[1]);
	let idx = Number(e.target.name.split("_")[1]);
	let rightAnswer = lookupAnswer(prob, idx);
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
