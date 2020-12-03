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
    console.log('admin firestore: ' + admin.firestore());
    const db = admin.firestore();
    const userRefs = db.collection('users');

    const userSnap = await userRefs.where('user_id', '==', post.user_id).get();

    if (userSnap.empty) {
       console.log('NO');
       return;
    }
    var user;
    var username
    userSnap.forEach(doc => {
        console.log(doc.id, '=>', doc.data());
        username = doc.get("user_username");
    });
    console.log('user: ' + user);
    console.log('username: ' + username);
    const notificationContent = {
      notification: {
        title: 'New post from ' + username,
        body: post.description.toString(),
      }
    };
    console.log('Sent Notification');
    return admin.messaging().sendToTopic(post.user_id, notificationContent);
    });