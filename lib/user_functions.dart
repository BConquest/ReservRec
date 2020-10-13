import 'dart:async';
import 'package:reservrec/file_functions.dart';

Future<bool> loginUser(String username, String password) async {
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