// The Cloud Functions for Firebase SDK to create Cloud Functions and setup triggers.
const functions = require('firebase-functions');

// The Firebase Admin SDK to access Cloud Firestore.
const admin = require('firebase-admin');
admin.initializeApp();

exports.notifyOnNewPost = functions.firestore.document('/posts/{post_id}')
  .onCreate((snapshot, context) => {
    console.log(context.params.post_id);
    console.log(snapshot.data);

    const notificationContent = {
      notification: {
        title: 'New message',
        body: 'New Post',
        icon: 'default'
      }
    };
    console.log('Sent Notification')
    return admin.messaging().sendToTopic('posts', notificationContent)
    });