// Thanks https://ptyagicodecamp.github.io/persisting-data-in-local-db-for-flutter-android-ios.html

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:reservrec/models/post.dart';
import 'package:reservrec/models/user.dart';
import 'package:reservrec/src/user_functions.dart' as uf;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final reference = FirebaseFirestore.instance;
var sortIndex = 0;
var mode = false;
var seeUserPosts = false;
final List sortMethod = ['time', 'max-people', '> cur', '< cur'];

class PostModel {
  final int id;
  final String author;
  final String auth_name;
  final String auth_email;
  final String sport;
  final String desc;
  final String loc;
  final DateTime postTime;
  final DateTime gameTime;
  final int maxPlayers;
  final int minPlayers;
  final int curPlayers;
  final String auth_pic;


  const PostModel({
    this.id,
    this.author,
    this.auth_name,
    this.auth_email,
    this.sport,
    this.desc,
    this.loc,
    this.postTime,
    this.gameTime,
    this.maxPlayers,
    this.minPlayers,
    this.curPlayers,
    this.auth_pic
  });
}

int getSortIndex() {
  return sortIndex;
}

void setSortIndex(final int n) {
  sortIndex = n;
}

int cycleFunction() {
  if (sortIndex == sortMethod.length - 1) {
    sortIndex = 0;
  } else {
    sortIndex += 1;
  }
  return sortIndex;
}

Future<List<PostModel>> grabFeed(int sortMethodIndex) async {
  final CollectionReference postsCollection = FirebaseFirestore.instance.collection('posts');
  final QuerySnapshot snapshot = await postsCollection.orderBy('time_posted', descending: true).get();

  List<Post> posts = List();

  String f = await uf.getCurrentSchool();
  snapshot.docs.forEach((document) async {
    if(Post.fromJson(document.data()).school == f) {
      posts.add(Post.fromJson(document.data()));
    }
  });

  List<String> friends =  await getFriendsList(_auth.currentUser.uid);
  if (seeUserPosts || sortMethodIndex < 0) {
    posts.retainWhere((element) => element.postUserId == _auth.currentUser.uid);
  } else {
    posts.removeWhere((element) => element.postUserId == _auth.currentUser.uid);
  }

  if (mode) {
    posts.retainWhere((element) => friends.contains(element.postUserId));
  }

  if (sortMethodIndex == -1 && posts.length > 1){
    int flag = 0;
    List<Post> temp = List();
    List<Post> sublist = List();
    int count = 0;
    int rec = 0;
    posts.sort((a, b) {
      return a.postLocation.toString().toLowerCase().compareTo(b.postLocation.toString().toLowerCase());
    });
    for(int i = 0; i < posts.length; i++) print(posts[i].postSport + " " + posts[i].postLocation);
    for(int i = 0; i < posts.length - 1; i++){
      if(posts[i].postLocation == posts[i+1].postLocation && i != posts.length-2) {
        count++;
        continue;
      }
      else {
        if(i == posts.length-2 && posts[i].postLocation == posts[i+1].postLocation){
          flag = 1;
          rec = 1;
        }
        sublist = posts.sublist(i - count, i + 1 + rec);
        for(int j = 0; j < sublist.length; j++) print(sublist[j].postSport + " " + sublist[j].postLocation + " " + count.toString());
        if(sublist.length > 1) {
          sublist.sort((a, b) {
            return a.postTimeSet.toString().toLowerCase().compareTo(
                b.postTimeSet.toString().toLowerCase());
          });
        }
        temp.addAll(sublist);
        count = 0;
        if(flag == 0) temp.add(posts[posts.length-1]);
      }
    }
    print(temp.length);
    for(int i = 0; i < temp.length; i++) print(temp[i].postSport);
    posts.clear();
    posts.addAll(temp);
  }

  else if (sortMethodIndex == 0 || sortMethodIndex == -2) {
    posts.sort((a, b) {
      return a.postTimeSet.toString().toLowerCase().compareTo(b.postTimeSet.toString().toLowerCase());
    });
  } else if (sortMethodIndex == 1) {
    posts.sort((a, b) {
      return b.maxPeople.compareTo(a.maxPeople);
    });
  } else if (sortMethodIndex == 2){
    posts.sort((a, b) {
      return b.curPeople.compareTo(a.curPeople);
    });
  } else {
    posts.sort((a, b) {
      return a.curPeople.compareTo(b.curPeople);
    });
  }

  // Begin spaghetti code, brought to you by Zack Withers
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');
  final QuerySnapshot ss = await userCollection.get();

  List<UserC> users = List();
  ss.docs.forEach((document) async {
    users.add(UserC.fromJson(document.data()));
  });

  return List.generate(
    posts.length,
        (i) {
          final id = posts[i].postId;
          final auth = posts[i].postUserId;
          final authN = users[users.indexWhere((element) => (element.userId == posts[i].postUserId))].userUsername;
          final authE = users[users.indexWhere((element) => (element.userId == posts[i].postUserId))].userEmail;
          final spo = posts[i].postSport;
          final des = posts[i].postDescription;
          final loc = posts[i].postLocation;
          final pt = posts[i].postTimePosted;
          final gt = posts[i].postTimeSet;
          final max = posts[i].maxPeople;
          final min = posts[i].minPeople;
          final cur = posts[i].curPeople;
          final authP = users[users.indexWhere((element) => (element.userId == posts[i].postUserId))].photoURL;

          return PostModel(
          id: id,
          author: auth,
          auth_name: authN,
          auth_email: authE,
          sport: spo,
          desc: des,
          loc: loc,
          postTime: pt,
          gameTime: gt,
          maxPlayers: max,
          minPlayers: min,
          curPlayers: cur,
          auth_pic: authP
      );
    },
  );
}

Future<String> newPost(String sport, String description, String location, DateTime gameTime, int max, int min) async {
  final CollectionReference postsCollection = FirebaseFirestore.instance.collection('posts');
  QuerySnapshot query = await postsCollection.orderBy("post_id").limitToLast(1).get();          //grabs post with greatest id
  int newID = 1 + Post.fromJson(query.docs.first.data()).postId;                              //extracts id and increments, though this creates issues with more than one app adding posts at the same time
  final uid = _auth.currentUser.uid;

  String school = await uf.getCurrentSchool();

  Post tempPost = Post(uid, newID, postSport: sport, postDescription: description, postLocation: location, school: school, postTimeSet: gameTime, postTimePosted: DateTime.now(), maxPeople: max, minPeople: min, curPeople: 1);
  await postsCollection.add(tempPost.toJson());

  String id = await getDocumentID(newID);

  await reference.collection('posts').doc(id).collection('cur_users').doc(_auth.currentUser.uid).set({});

  return "true";
}

void newLocation(String name, double lat, double long, String school) async {
  final CollectionReference locations = FirebaseFirestore.instance.collection('schools').doc(school).collection('validLocations');
  await locations.add({'lat':lat, 'locationName':name, 'long':long});
}

void newEmail(String domain, String school) async {
  final CollectionReference locations = FirebaseFirestore.instance.collection('schools').doc(school).collection('validEmails');
  await locations.add({'domain': domain});
}

Future<void> deletePost(final post_id) async {
  String docid = await getDocumentID(post_id);
  print("Doc id is: " + docid);
  await firestoreInstance.collection('posts').doc(docid).delete();
}

Future<String> getDocumentID(final post_id) async {
  String id;
  await firestoreInstance.collection("posts").where("post_id", isEqualTo:post_id).get().then((value) {
    id = value.docs[0].id.toString();
    print("(II) getDocumentID $id");
  });
  return id;
}

Future<String> getDocumentUID(final uid) async {
  var id;
  await firestoreInstance.collection("users").where("user_id", isEqualTo:uid).get().then((value) {
    id = value.docs[0].id;
  });
  return id.toString();
}


Future<List<String>> getFriendsList(final String uid) async {
  List<String> friends = List();
  final String documentID = await getDocumentUID(uid);
  CollectionReference userFollowingCollection = firestoreInstance.collection("users").doc(documentID).collection("following");

  await userFollowingCollection.get().then((value) {
    value.docs.forEach((element) {
      friends.add(element.id);
    });
  });

  return friends;
}