import 'dart:async';
import 'package:reservrec/file_functions.dart';

class User {
  final int userID;
  final String name;
  final String email;
  final String password;
  final String picture;
  final String school;
  final bool verified;

  User({
    this.userID,
    this.name,
    this.email,
    this.password,
    this.picture,
    this.school,
    this.verified,
  });
}

// isInitialRead = true then
Future<bool> loginUser(String email, String password, bool isInitialRead) async {
  List users;
  if (isInitialRead) {
    users = await loadInitialCSV("reservrec.csv");
    writeInitialCSV("reservrec.csv");
  } else {
    users = await loadLocalCSV("reservrec.csv");
  }
  for (var i = 0; i < users.length; i++) {
    if (users[i][3] == email && users[i][2] == password) {
      return Future.value(true);
    }
    print(users[i][3]);
    print(users[i][2]);
  }
  return Future.value(false);
}

Future<bool> newUser(String username, String password, String confirmPassword, String email) async {
  if (!validPassword(password, confirmPassword)) {
    return false;
  }
  if (!validEmail(email)) {
    return false;
  }

  List users;
  if (await isInitialRead("reservrec.csv")) {
    users = await loadInitialCSV("reservrec.csv");
    writeInitialCSV("reservrec.csv");
  } else {
    users = await loadLocalCSV("reservrec.csv");
  }

  final temp = User(
      userID: users.length,
      name: username,
      email: email,
      password: password,
      picture: "default",
      school: "University of Alabama",
      verified: false);
  print(temp);
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