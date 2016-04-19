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


Template.feed.onCreated(function () {
    this.autorun(() => {

	this.subscribe('posts');

    });
});

Template.feed.helpers({
    posts () {
	return Posts.find({}, {sort: {postedAt: -1}}).fetch();
    }
});

Template.postbox.events({
    'submit #postbox' (event) {
	event.preventDefault();
	let content = event.target.content.value;
	event.target.content.value = "";
	Posts.insert({ content: content});
    }
    
});
