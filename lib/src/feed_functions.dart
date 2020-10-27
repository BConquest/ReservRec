// Thanks https://ptyagicodecamp.github.io/persisting-data-in-local-db-for-flutter-android-ios.html

import 'dart:async';
import 'package:reservrec/models/post.dart';
import 'package:reservrec/src/file_functions.dart';
import 'package:reservrec/src/main.dart';
import 'package:reservrec/src/post.dart';
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
  CollectionReference postsCollection = FirebaseFirestore.instance.collection('posts');
  QuerySnapshot snapshot = await postsCollection.get();

  List<Post> posts;
  for(int i = 0; i < snapshot.size; i++) {
    Post tempPost = new Post(-1, -1);
    tempPost = Post.fromJson(snapshot.docs[i].data());
    print(tempPost);
    print(i);
    posts[i] = tempPost;  //the code always freezes whenever I try to add to posts and its driving me insane
  }                       //doesn't matter if I do it this way or as posts.add(tempPost), it always halts here

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
  List posts = await loadLocalCSV("feed.csv");

  final temp = PostModel(
    id: posts.length+1,
    author: 0,
    sport: sport,
    desc: description,
    loc: location,
    postTime: DateTime.now(),
    gameTime: DateTime.now(),  //FIX, need to let people actually pick a time
    maxPlayers: max,
    minPlayers: min
  );
  // Old CSV Code
  /*String newPostString = temp.id.toString() + ",";
  newPostString += temp.author.toString() + ",";
  newPostString += temp.desc + ",";
  newPostString += temp.postTime + ",";
  newPostString += temp.gameTime + ",";
  newPostString += temp.sport + ",";
  newPostString += temp.loc + ",";
  newPostString += temp.maxPlayers.toString() + ",";
  newPostString += temp.minPlayers.toString() + ";";
  print(newPostString);
  writeNewLine("/feed.csv", newPostString);*/
  return "true";
}