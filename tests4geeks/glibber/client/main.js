import { Template } from 'meteor/templating';
import { Meteor } from 'meteor/meteor';
import { ReactiveVar } from 'meteor/reactive-var';

import './main.html';

import { Profiles } from '../profiles.js';
import { Posts } from '../posts.js';

Meteor.subscribe('profiles');

Template.usernav.events({
    'blur #screenname' : (event) => {
	let profile = Meteor.user().profile();
	let newNick = event.currentTarget.value;
	if (!profile) {
	    Profiles.insert({ nick:   newNick});
	} else {
	    Profiles.update( profile._id, {$set: {nick: newNick}});
	}
    }
});

