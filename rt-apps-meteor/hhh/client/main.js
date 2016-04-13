import { Template } from 'meteor/templating';
import { Session } from 'meteor/session';

import { Players } from '../players.js';
import { Pellets } from '../pellets.js';

import './main.html';

Template.game.onRendered( function () {
    let that = this;
    Tracker.autorun(function () {
	
	let gamecanvas = that.find('#gamecanvas'); // get canvas from dom
	let ctx = gamecanvas.getContext('2d');     // get its 2d drawing context
	
	ctx.fillStyle = "rgb(45,45,45)";
	ctx.fillRect(0,0,400,400);
	
	let players = Players.find().fetch();
	//    console.log(players.count());
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
});

Template.game.onCreated( () => {

    let randomColor = function () {
	let r = Math.floor(Math.random() * 255);
	let g = Math.floor(Math.random() * 255);
	let b = Math.floor(Math.random() * 255);
	return 'rgb(' + r + ',' + g + ',' + b + ')';
    };
    
    Session.set('playerid', Players.insert({
	x: Math.round(Math.random() * 400),
	y: Math.round(Math.random() * 400),
	color: randomColor(),
	points: 0,
	lastActive: new Date()
    }));

});

const STEP_SIZE = 18;

Template.game.events({
    'click' (event) {
	let playerid = Session.get('playerid');
	let player = Players.findOne(playerid);
	let dx = event.offsetX - player.x;
	let dy = event.offsetY - player.y;
	let dist = Math.sqrt( dx*dx + dy*dy);
	let newx =  player.x + dx * (STEP_SIZE / dist);
	let newy =  player.y + dy * (STEP_SIZE / dist);
	

	let gotPellet = Pellets.findOne({ $and: [ { x : {$gte: newx - 10}},
						  { x : {$lte: newx + 10}},
						  { y : {$gte: newy - 10}},
						  { y : {$lte: newy + 10}}]});
	if (gotPellet) {
	    Pellets.remove(gotPellet._id);
	    Players.update( playerid,
			    {$set: {x : newx,
				    y : newy,
				    points: player.points + 1,
				    lastActive: new Date()}});
	    
	} else {
	    Players.update( playerid,
			    {$set: {x : newx,
				    y : newy,
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
