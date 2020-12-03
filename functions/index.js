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
    console.log('admin firestore: ' + admin.firestore())
    const db = admin.firestore();
    const querySnapshot = db
      .collection('users')
    console.log('querySnapshot: ' + typeof querySnapshot);
    console.log('post.user_id: ' + post.user_id)
    console.log('query doc: ' + typeof querySnapshot.doc)
    querySnapshot.forEach(doc => {
      console.log('forEach: ' + doc.user_id);
    });
    console.log('user: ' + user.username.toString());


    const notificationContent = {
      notification: {
        title: 'New post from ' + user.username.toString(),
        body: post.description.toString(),
      }
    };
    console.log('Sent Notification')
    return admin.messaging().sendToTopic(post.user_id, notificationContent)
    });