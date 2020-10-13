import 'dart:async';
import 'package:reservrec/file_functions.dart';

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