import 'package:reservrec/test_users.dart';

bool loginUser(String username, String password) {
  /*
  Todo
  Switch to grep from sqlite db
   */
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