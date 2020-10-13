import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:csv/csv_settings_autodetection.dart';
import 'package:reservrec/test_users.dart';
import 'package:reservrec/main.dart';

import 'package:csv/csv.dart';
import 'package:path_provider/path_provider.dart';

import 'package:flutter/services.dart' show rootBundle;

class User {
  final int    userid;
  final String username;
  final String password;
  final String email;
  final bool   verified;
  final String picture;
  final String school;

  User({this.userid, this.username, this.password, this.email, this.verified, this.picture, this.school});

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

Future<String> get _localPath async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

Future<File> get _localFile async {
  final path = await _localPath;
  return File('$path/assets/reservrec.csv');
}

Future<String> loadAsset() async {
  return await rootBundle.loadString('assets/reservrec.csv');
}

Future<List> loadCSV() async {
  String fileContents = await loadAsset();

  const conv = const CsvToListConverter(eol: ';');
  final res = conv.convert(fileContents);
  return res;
}

Future<bool> loginUser(String username, String password) async {
  /*
  Todo
  Switch to grep from sqlite db
   */
  List path = await loadCSV();

  for (var i = 0; i < path.length; i++) {
    if (path[i][1] == username && path[i][2] == password) {
      return Future.value(true);
    }
    print(path[i][1]);
    print(path[i][2]);
  }
  return Future.value(false);
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