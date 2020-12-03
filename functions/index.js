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

exports.followerNotification = functions.firestore.document('/posts/{post_id}')
  .onCreate(async (snapshot, context) => {
    post = snapshot.data();
    const db = admin.database().ref('/users/');
    console.log('user_id: ' + post.user_id);
    const userSnapshot = await db.where('user_id', '==', post.user_id).get();
    if (userSnapshot.empty) {
      console.log('No matching documents.');
      return;
    }
    userSnapshot.forEach(doc => {
      console.log('Doc found: ' + doc.user_id);
    });

    const notificationContent = {
      notification: {
        title: 'New post from ' + post.user_id,
        body: post.description.toString(),
      }
    };
    console.log('Sent Notification')
    return admin.messaging().sendToTopic(post.user_id, notificationContent)
    });