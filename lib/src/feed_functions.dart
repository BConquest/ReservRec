// Thanks https://ptyagicodecamp.github.io/persisting-data-in-local-db-for-flutter-android-ios.html

import 'dart:async';
import 'package:reservrec/models/post.dart';
import 'package:reservrec/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
var sortIndex = 0;
final List sortMethod = ['time', 'people', 'location'];

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
    this.minPlayers
  });
}

int getSortIndex() {
  return sortIndex;
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

  List<Post> posts = new List();
  snapshot.docs.forEach((document) async {
    posts.add(Post.fromJson(document.data()));
  });

  if (sortMethodIndex == 0) {
    posts.sort((a, b) {
      return a.postTimeSet.toString().toLowerCase().compareTo(b.postTimeSet.toString().toLowerCase());
    });
  } else if (sortMethodIndex == 1) {
    posts.sort((a, b) {
      //TODO change to curPlayers
      return a.maxPeople.toString().toLowerCase().compareTo(b.maxPeople.toString().toLowerCase());
    });
  } else {
    posts.sort((a, b) {
      //TODO change to curPlayers
      return a.maxPeople.toString().toLowerCase().compareTo(b.maxPeople.toString().toLowerCase());
    });
    posts = posts.reversed;
  }
  print (sortMethodIndex);

  // Begin spaghetti code, brought to you by Zack Withers (#0 Gayball player in the world btw)
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');
  final QuerySnapshot ss = await userCollection.get();

  List<UserC> users = new List();
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
          minPlayers: min
      );
    },
  );
}

Future<String> newPost(String sport, String description, String location, DateTime gameTime, int min, int max) async {
  final CollectionReference postsCollection = FirebaseFirestore.instance.collection('posts');
  QuerySnapshot query = await postsCollection.orderBy("post_id").limitToLast(1).get();          //grabs post with greatest id
  int newID = 1 + Post.fromJson(query.docs.first.data()).postId;                              //extracts id and increments, though this creates issues with more than one app adding posts at the same time
  print("newID: $newID");

  Post tempPost = new Post(_auth.currentUser.uid, newID, postSport: sport, postDescription: description, postLocation: location, postTimeSet: gameTime, postTimePosted: DateTime.now(), maxPeople: max, minPeople: min);
  postsCollection.add(tempPost.toJson());
  return "true";
}
