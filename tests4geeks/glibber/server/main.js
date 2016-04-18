import { Meteor } from 'meteor/meteor';

import { Profiles } from '../profiles.js';
import { Posts } from '../posts.js';

Profiles.before.insert( (uid, doc) => {
    doc.createdAt = Date.now();
    doc.userId = uid;
});

Meteor.startup(() => {
  // code to run on server at startup
});

Meteor.publish('profiles', () => { return Profiles.find(); });


