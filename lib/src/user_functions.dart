import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final firestoreInstance = FirebaseFirestore.instance;

var createUserMessage = "";
String dropdownValue = 'University of Alabama';

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
  } catch (e) {
    print(e);
  }
  return user;
}

String getDropDownValue() {
  return dropdownValue;
}

Future<User> signUpWithEmailAndPassword(String username, String password, String confirmPassword, String email) async {
  User user;
  if (!(await validEmail(email))) {
    createUserMessage = "Invalid Email";
    return user;
  }
  if (!validPassword(password, confirmPassword)) {
    createUserMessage = "Invalid Password";
    return user;
  }

  try {
    user = (await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    ))
        .user;
  } catch (e) {
    print("user_functions->signUpWithEmailAndPassword $e");
    createUserMessage = e.toString();
    return user;
  }
  return user;
}

Future<bool> validEmail(String email) async {
  List validEmailEndings = await getEmails(dropdownValue);
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

Future<String> signInWithUsernameAndPassword(String username, String password) async {
  String email;
  await firestoreInstance.collection("users").where("user_username", isEqualTo: username).get().then((value){
    value.docs.forEach((element) {
      email = element.data()["user_email"];}
    );
  });
  return email;
}

Future<List<String>> getSchools() async {
  List<String> schools = new List();
  await firestoreInstance.collection("schools").get().then((value){
    value.docs.forEach((element) {
      schools.add(element.data()["name"]);}
    );
  });
  return schools;
}

Future<List<String>> getEmails(String school) async {
  CollectionReference schools = FirebaseFirestore.instance.collection('schools');

  schools.collection("schools").doc(school).collection("domains").get();
  FirebaseFirestore.instance
      .collection('schools')
      .get()
      .then((QuerySnapshot querySnapshot) => {
        querySnapshot.docs.contains(element)
      });
  print(schools);
  //  return schools;
}