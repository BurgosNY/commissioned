import { Template } from 'meteor/templating';
import { Session } from 'meteor/session';

import { Players } from '../players.js';
import { Pellets } from '../pellets.js';

import './main.html';

var updateGameBoard = function (gamecanvas) {
    Tracker.autorun(function () {
	

	let ctx = gamecanvas.getContext('2d');     // get its 2d drawing context
	
	ctx.fillStyle = "rgb(45,45,45)";
	ctx.fillRect(0,0,400,400);
	
	let players = Players.find().fetch();
	players.forEach( (p) => {
	    ctx.fillStyle = p.color;
	    ctx.beginPath();
	    ctx.moveTo(p.x, p.y);
	    ctx.arc( p.x, p.y, 20, 0, 2 * Math.PI);
	    ctx.fill();
	});

	let pellets = Pellets.find().fetch();
	pellets.forEach( (p) => {
	    ctx.fillStyle = "black";
	    ctx.fillRect(p.x - 5, p.y - 5, 10, 10);
	});
    });
}

Template.game.onRendered( function () {
    let gamecanvas = this.find('#gamecanvas'); // get canvas from dom
    updateGameBoard(gamecanvas);
});

let randomColor = function () {
    let r = Math.floor(Math.random() * 255);
    let g = Math.floor(Math.random() * 255);
    let b = Math.floor(Math.random() * 255);
    return 'rgb(' + r + ',' + g + ',' + b + ')';
};

const BOARD_SIZE = 400;

Template.game.onCreated( () => {

    Session.set('playerid', Players.insert({
	x: Math.round(Math.random() * BOARD_SIZE),
	y: Math.round(Math.random() * BOARD_SIZE),
	color: randomColor(),
	points: 0,
	lastActive: new Date()
    }));

});

const STEP_SIZE = 22;

let nearbyPelletQuery = function (newp) {
    return { $and: [ { x : {$gte: newp.x - 10}},
		     { x : {$lte: newp.x + 10}},
		     { y : {$gte: newp.y - 10}},
		     { y : {$lte: newp.y + 10}}]};
};

let newPosition = function ( event, player) {
    let dx = event.offsetX - player.x;
    let dy = event.offsetY - player.y;
    let dist = Math.sqrt( dx*dx + dy*dy);
    let newx =  player.x + dx * (STEP_SIZE / dist);
    let newy =  player.y + dy * (STEP_SIZE / dist);
    return {x:newx, y:newy};
};

Template.game.events({
    'click' (event) {
	let player = Players.findOne(Session.get('playerid')); 

	let newPos = newPosition(event, player);
	
	let gotPellet = Pellets.findOne( nearbyPelletQuery( newPos ) );
	
	if (gotPellet) {
	    Pellets.remove(gotPellet._id);
	    Players.update( player._id,
			    {$set: {x : newPos.x,
				    y : newPos.y,
				    points: player.points + 1,
				    lastActive: new Date()}});
	    
	} else {
	    Players.update( player._id,
			    {$set: {x : newPos.x,
				    y : newPos.y,
				    lastActive: new Date()}});
	}
    }
});

Template.points.helpers({
    getPoints () { return Players.findOne(Session.get('playerid')).points;},
});

Template.otherPoints.helpers({
    players () { return Players.find({_id: {$not: Session.get('playerid')}})}
});
