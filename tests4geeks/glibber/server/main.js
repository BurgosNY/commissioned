import { Meteor } from 'meteor/meteor';

import { Profiles } from '../profiles.js';
import { Posts } from '../posts.js';

Profiles.before.insert( (uid, doc) => {
    doc.createdAt = new Date(); //Date.now();
    doc.userId = uid;
});

Profiles.before.update( function (uid, doc, fields, mod, opts) {
    mod.$set = mod.$set || {};
    mod.$set.changedAt = new Date(); //Date.now();
});

Posts.before.insert( function (uid, doc) {
    doc.postedAt = new Date(); // Date.now();
    doc.userId = uid;
});

//Posts.before.find

Meteor.startup(() => {
  // code to run on server at startup
});

Meteor.publish('profiles', () => { return Profiles.find(); });
Meteor.publish('posts', () => { return Posts.find(); });



