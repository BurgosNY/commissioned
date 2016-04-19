import { Mongo } from 'meteor/mongo';
import { Profiles } from './profiles.js';

export const Posts = new Mongo.Collection('posts');

Posts.helpers({

    nick () {
	return Profiles.findOne({userId: this.userId}).nick;
    },
    
    postDate () {
	let yesterday = new Date();
	yesterday.setDate( yesterday.getDate() - 1 ); 
	if (this.postedAt < yesterday) 
	    return this.postedAt.toDateString();
	return this.postedAt.toTimeString().split(' ')[0];

    }
});
