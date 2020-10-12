import 'package:reservrec/test_users.dart';
import 'package:reservrec/main.dart';

import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class User {
  final String username;
  final String password;
  final String email;
  final bool   verified;
  final String school;

  User({this.username, this.password, this.email, this.verified, this.school});

  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'password': password,
      'email': email,
      'verified': verified,
      'school': school,
    };
  }
}

void createTables() async {
  final Future<Database> database = openDatabase(
      join(await getDatabasesPath(), 'reservrec.db'),
      onCreate: (db, version) {
        db.execute(
          "CREATE TABLE Posts (post_id int NOT NULL PRIMARY KEY, post_user_id int, post_description varchar(255), time_posted date, time_set date, sport_type varchar(255), post_location varchar(255), max_people int, min_people int, FOREIGN KEY(post_user_id) REFERENCES Users(user_id))",
        );
        db.execute(
          "CREATE TABLE Users (user_id int NOT NULL PRIMARY KEY, username varchar(255) NOT NULL, password varchar(255) NOT NULL, email varchar(255), picture varbinary(8000), verified bit, school varchar(255))",
        );
        return db.execute(
          "CREATE TABLE PostStatus(post_status_id int, status varchar(8), FOREIGN KEY (post_status_id) REFERENCES Posts(post_id))"
        );
      },
      version: 1,
  );
}

Future<List<User>> users() async {
  createTables();
  final Future<Database> database = openDatabase(
    join(await getDatabasesPath(), 'reservrec.db'),
  );
  
  final Database db = await database;
  
  final List<Map<String, dynamic>> maps = await db.query('users');

  return List.generate(maps.length, (i) {
    return User(
      username: maps[i]['username'],
      password: maps[i]['password'],
      email: maps[i]['email'],
      verified: maps[i]['verified'],
      school: maps[i]['school']
    );
  });
}

bool loginUser(String username, String password) {
  /*
  Todo
  Switch to grep from sqlite db
   */
  print(users());
  if (testUsers[username] == password) {
    print("Login Successful");
    return true;
  } else {
    print("Login Failed");
    print(username);
    print(password);
    print(testUsers);
    return false;
  }
}

bool newUser(String username, String password, String confirmPassword, String email) {
  if (!validPassword(password, confirmPassword)) {
    return false;
  }
  if (!validEmail(email)) {
    return false;
  }
  /*
  Todo
  insert into sqlite;
   */

  return true;
}

bool validEmail(String email) {
  if (email.endsWith("@crimson.ua.edu")) {
    return true;
  }
  return false;
}

bool verifyPassword(String password, String confirmPassword) {
  if (password == confirmPassword) {
    return true;
  } else {
    return false;
  }
}

bool validPassword(String password, String confirmPassword) {
  if (!verifyPassword(password, confirmPassword)) {
    return false;
  }
  if (password.length < 8) {
    return false;
  }
  return true;
}