import 'dart:async';
import 'package:reservrec/file_functions.dart';
import 'package:reservrec/main.dart';

class User {
  int userID;
  String name;
  String email;
  String password;
  String picture;
  String school;
  bool verified;

  User({
    this.userID,
    this.name,
    this.email,
    this.password,
    this.picture,
    this.school,
    this.verified,
  });

  Map<String, dynamic> toMap() {
    return {
      'userID': userID,
      'name': name,
      'email': email,
      'password': password,
      'picture': picture,
      'school': school,
      'verified': verified
    };
  }
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
  print('users: $users');
  print(users);
  print(users[5]);
  for (var i = 0; i < users.length; i++) {
    print(users[i]);
    if (users[i][3] == email && users[i][2] == password) {
      Me.userID = users[i][0];
      Me.name = users[i][1];
      Me.email = users[i][3];
      Me.password = users[i][2];
      Me.picture = users[i][4];
      Me.school = users[i][6];
      if(users[i][5] == 1) {
        Me.verified = true;
      } else {
        Me.verified = false;
      }
      return Future.value(true);
    }
  }
  return Future.value(false);
}

Future<String> newUser(String username, String password, String confirmPassword, String email) async {
  if (!validPassword(password, confirmPassword)) {
    return "Invalid Password";
  }
  if (!validEmail(email)) {
    return "Invalid Email";
  }

  List users;
  if (await isInitialRead("reservrec.csv")) {
    users = await loadInitialCSV("reservrec.csv");
    writeInitialCSV("reservrec.csv");
  } else {
    users = await loadLocalCSV("reservrec.csv");
  }

  final temp = User(
      userID: users.length+1,
      name: username,
      email: email,
      password: password,
      picture: "default",
      school: "University of Alabama",
      verified: false);
  String newUserString = temp.userID.toString() + ",";
  newUserString += temp.name + ",";
  newUserString += temp.password + ",";
  newUserString += temp.email + ",";
  newUserString += "NULL" + ",";
  newUserString += "0" + ",";
  newUserString += temp.school + ";";
  print(newUserString);
  writeNewLine("/reservrec.csv", newUserString);
  return "true";
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
  if (password.length < 2) {
    return false;
  }
  return true;
}