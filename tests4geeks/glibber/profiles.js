import { Mongo } from 'meteor/mongo';
import { Meteor } from 'meteor/meteor';

export const Profiles = new Mongo.Collection('profiles');

Meteor.users.helpers({
    nick () {
	return Profiles.findOne({userId: this._id}).nick;
    },

    profile () {
	return Profiles.findOne({userId: this._id});
    }
    
});


