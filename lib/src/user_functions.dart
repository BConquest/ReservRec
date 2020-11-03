import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final firestoreInstance = FirebaseFirestore.instance;

var createUserMessage = "";

class UserClass {
  int userID;
  String name;
  String email;
  String password;
  String picture;
  String school;
  bool verified;

  UserClass({
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

Future<User> signInWithEmailAndPassword(String email, String password) async {
  User user;
  try {
    user = (await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    ))
        .user;
    print(user);
  } catch (e) {
    print(e);
  }
  return user;
}

Future<User> signUpWithEmailAndPassword(String username, String password, String confirmPassword, String email) async {
  User user;
  if (!validPassword(password, confirmPassword)) {
    print("user_functions->signUpWithEmailAndPassword Invalid Password");
    createUserMessage = "Invalid Password";
  }
  if (!validEmail(email)) {
    print("user_functions->signUpWithEmailAndPassword Invalid Email");
    createUserMessage = "Invalid Email";
  }

  try {
    user = (await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    ))
        .user;
    print(user);
  } catch (e) {
    print("user_functions->signUpWithEmailAndPassword $e");
    createUserMessage = e.toString();
    return user;
  }
  return user;
}

bool validEmail(String email) {
  if (email.endsWith("@crimson.ua.edu")) {
    return true;
  }
  return false;
}

bool verifyUsername(String username) {
  if (username.length < 3 || username.length > 10) {
    return false;
  }
  for (int i = 0; i < username.length; i++) {
    if (!username[i].startsWith(RegExp(r'[A-Za-z0-9]'))) {
      return false;
    }
  }
  return true;
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

void signInWithUsernameAndPassword(String username, String password) async {
  firestoreInstance.collection("users").where("user_username", isEqualTo: username).get().then((value){
    value.docs.forEach((element) {print(element.data);}
    );
  });
}