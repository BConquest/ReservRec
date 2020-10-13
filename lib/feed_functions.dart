// Thanks https://ptyagicodecamp.github.io/persisting-data-in-local-db-for-flutter-android-ios.html

import 'dart:async';
import 'package:reservrec/file_functions.dart';
import 'package:reservrec/main.dart';

class PostModel {
  final int id;
  final int author;
  final String auth_name;
  final String auth_email;
  final String sport;
  final String desc;
  final String loc;
  final String postTime;
  final String gameTime;
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
  List posts;
  List users = await loadLocalCSV("reservrec.csv");
  final isInit = await isInitialRead("/feed.csv");
  final isInitF = (isInit == false);
  print(isInitF);
  if (isInitF) {
    posts = await loadInitialCSV("feed.csv");
    writeInitialCSV("feed.csv");
  } else {
    posts = await loadLocalCSV("/feed.csv");
  }

  print(posts);

  print(users[0][1]);
  return List.generate(
    posts.length,
        (i) {
      final id = posts[i][0];
      final auth = posts[i][1];
      final auth_n = users[auth-1][1];
      final auth_e = users[auth-1][3];
      final spo = posts[i][5];
      final des = posts[i][2];
      final loc = posts[i][6];
      final pt = posts[i][3];
      final gt = posts[i][4];
      final max = posts[i][7];
      final min = posts[i][8];

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
          minPlayers: min);
    },
  );
}

Future<String> newPost(String sport, String description, String location, String gameTime, int min, int max) async {
  List posts = await loadLocalCSV("feed.csv");

  final temp = PostModel(
    id: posts.length+1,
    author: Me.userID,
    sport: sport,
    desc: description,
    loc: location,
    postTime: "10-13-2020",
    gameTime: gameTime,
    maxPlayers: max,
    minPlayers: min
  );
  String newPostString = temp.id.toString() + ",";
  newPostString += temp.author.toString() + ",";
  newPostString += temp.desc + ",";
  newPostString += temp.postTime + ",";
  newPostString += temp.gameTime + ",";
  newPostString += temp.sport + ",";
  newPostString += temp.loc + ",";
  newPostString += temp.maxPlayers.toString() + ",";
  newPostString += temp.minPlayers.toString() + ";";
  print(newPostString);
  writeNewLine("/feed.csv", newPostString);
  return "true";
}