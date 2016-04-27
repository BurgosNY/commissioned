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


const rational = function (n,d) {
    return {numerator:n, denominator:d};
};

const additionProblem = function (id, summands) {
    let stringSummands = summands.map((s) => {return (s+"");});

    let maxlength = 0;
    stringSummands.forEach((s) => {
	maxlength = Math.max(maxlength, s.length);
    });

    let digitSummands = stringSummands.map((s) => {
	return padLeft(s," ", maxlength+1).split("");
    });

    let answer = summands.reduce((a,b) => {return a+b;});
    
    return {id: id,
	    type: "simple addition",
	    summands: digitSummands,
	    answer: padLeft(answer+""," ",maxlength+1).split("")
	   };
};

const exampleProblems = [
    additionProblem(0, [3749, 7392, 2027]),
    additionProblem(1, [174, 2392, 225])
];


Template.demoQuiz.helpers({
    problems () {
	return exampleProblems;
    }
});

Template.simpleAddition.helpers({
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
	    console.log("goodie");
	    $(e.target).attr("class", "cell correct");
	} else {
	    console.log("oh noes");
	    $(e.target).attr("class", "cell incorrect");
	}
    }
});
