import { Meteor } from 'meteor/meteor';
import { Players } from '../players.js';
import { Pellets } from '../pellets.js';

const PLAYER_TIMEOUT = 20000;

let cleanIdle = function () {
    let now = new Date();
    let toRemove = [];
    Players.find().forEach( (player) => {
	if (now - player.lastActive > PLAYER_TIMEOUT)
	    toRemove.push( player._id );
    });

    toRemove.forEach( (player) => { Players.remove( player ); });
    
};

let spawnPellets = function () {
    if (Math.random() > 0.7 && Pellets.find().count() < 30) {
	Pellets.insert({x: Math.floor(Math.random() * 400),
			y: Math.floor(Math.random() * 400)});
    }
};



Meteor.setInterval(cleanIdle, PLAYER_TIMEOUT + 1000);
Meteor.setInterval(spawnPellets, 1000);
