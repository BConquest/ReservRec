// Thanks https://ptyagicodecamp.github.io/persisting-data-in-local-db-for-flutter-android-ios.html

import 'dart:async';
import 'package:reservrec/file_functions.dart';

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

Future<List<PostModel>> grabFeed(bool isInitialRead) async {
  List posts;
  List users = await loadLocalCSV("reservrec.csv");
  if (isInitialRead) {
    posts = await loadInitialCSV("feed.csv");
    writeInitialCSV("feed.csv");
  } else {
    posts = await loadLocalCSV("feed.csv");
  }

  print(users[0][1]);
  return List.generate(
    posts.length - 1,
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
  /*List<PostModel> feed;
  feed.insert(0, PostModel(
      id: 1,
      author: 1,
      sport: "nuts",
      desc: "balls",
      loc: "ur m0m",
      postTime: "today",
      gameTime: "neVer",
      maxPlayers: 2,
      minPlayers: 1
  ));
  print(feed);
  for (var i = 0; i < posts.length - 1; i++) {
    print(i);
    feed.add(PostModel(
      id: posts[i][0],
      author: posts[i][1],
      sport: posts[i][5],
      desc: posts[i][2],
      loc: posts[i][6],
      postTime: posts[i][3],
      gameTime: posts[i][4],
      maxPlayers: posts[i][7],
      minPlayers: posts[i][8]
    ));
  }*/
}