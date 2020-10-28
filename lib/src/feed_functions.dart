// Thanks https://ptyagicodecamp.github.io/persisting-data-in-local-db-for-flutter-android-ios.html

import 'dart:async';
import 'package:reservrec/models/post.dart';
import 'package:reservrec/src/file_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PostModel {
  final int id;
  final int author;
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

Future<List<PostModel>> grabFeed() async {
  final CollectionReference postsCollection = FirebaseFirestore.instance.collection('posts');
  final QuerySnapshot snapshot = await postsCollection.get();

  List<Post> posts = new List();
  snapshot.docs.forEach((document) async {
    print(document.id);
    posts.add(Post.fromJson(document.data()));
    print("we did it");
  });

  return List.generate(
    posts.length,
        (i) {
      final id = posts[i].post_id;
      final auth = 0;
      final auth_n = "Name";
      final auth_e = "Email";
      final spo = posts[i].post_sport;
      final des = posts[i].post_description;
      final loc = posts[i].post_location;
      final pt = posts[i].post_time_posted;
      final gt = posts[i].post_time_set;
      final max = posts[i].max_people;
      final min = posts[i].min_people;

      return PostModel(
          id: id,
          author: auth,
          auth_name: auth_n,
          auth_email: auth_e,
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

Future<String> newPost(String sport, String description, String location, String gameTime, int min, int max) async {
  final CollectionReference postsCollection = FirebaseFirestore.instance.collection('posts');
  QuerySnapshot query = await postsCollection.orderBy("post_id").limitToLast(1).get();          //grabs post with greatest id
  int newID = 1 + Post.fromJson(query.docs.first.data()).post_id;                               //extracts id and increments, though this creates issues with more than one app adding posts at the same time
  print("newID: $newID");

  Post tempPost = new Post(0, newID, post_sport: sport, post_description: description, post_location: location, post_time_set: DateTime.now(), post_time_posted: DateTime.now(), min_people: min, max_people: max);
  postsCollection.add(tempPost.toJson());
  return "true";
}