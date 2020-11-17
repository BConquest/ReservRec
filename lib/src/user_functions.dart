import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final firestoreInstance = FirebaseFirestore.instance;

String dropdownValue = 'Please Select a Value';
String dropdownLocationValue = 'Please Select a Value';

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

Future<String> getDocumentID(final uid) async {
  print(uid);
  var id;
  await firestoreInstance.collection("users").where("user_id", isEqualTo:uid).get().then((value) {
    id = value.docs[0].id;
  });
  return id.toString();
}

Future<String> getCurrentProfilePicture(uid) async {
  String photoURL;
  await firestoreInstance.collection('users').where("user_id", isEqualTo: uid).get().then((value){
    value.docs.forEach((element) {photoURL = element.data()["photoURL"].toString();});
  });
  return photoURL;
}

Future<void> setCurrentProfilePicture(photoURL) async {
  await firestoreInstance.collection('users').doc(await getDocumentID(_auth.currentUser.uid)).update({'photoURL': photoURL});
}

Future<void> setCurrentUsername(username) async {
  await firestoreInstance.collection('users').doc(await getDocumentID(_auth.currentUser.uid)).update({'user_username': username});
}

Future<String> getCurrentUsername(uid) async {
  String username;
  await firestoreInstance.collection('users').where("user_id", isEqualTo: uid).get().then((value){
    value.docs.forEach((element) {username = element.data()["user_username"].toString();});
  });
  return username;
}

Future<String> getCurrentEmail(uid) async {
  String email;
  await firestoreInstance.collection('users').where("user_id", isEqualTo: uid).get().then((value){
    value.docs.forEach((element) {email = element.data()["user_email"].toString();});
  });
  return email;
}

Future<String> getCurrentSchool() async {
  final User user = _auth.currentUser;
  final uid = user.uid;
  print("user: $uid");

  String school;
  await firestoreInstance.collection('users').where("user_id", isEqualTo: uid).get().then((value){
    value.docs.forEach((element) {school = element.data()["school"].toString();});
  });
  return school;
}

String getDropDownValue() {
  return dropdownValue;
}

Future<User> signUpWithEmailAndPassword(String username, String password, String confirmPassword, String email) async {
  User user;
  if (!(await validEmail(email))) {
    return user;
  }
  if (!validPassword(password, confirmPassword)) {
    return user;
  }

  try {
    user = (await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    )).user;
  } catch (e) {
    print("user_functions->signUpWithEmailAndPassword $e");
    return user;
  }
  return user;
}

Future<bool> validEmail(String email) async {
  List validEmailEndings = await getEmails(dropdownValue);

  for (var i = 0; i < validEmailEndings.length; i++) {
    if (email.endsWith(validEmailEndings[i].toString())) {
      return true;
    }
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
  RegExp isValid = RegExp(r'^(.{0,7}|[^0-9]*|[^A-Z]*|[^a-z]*)$');
  if (password != confirmPassword) {
    return false;
  } else if (isValid.hasMatch(password)) {
    return false;
  } else {
    return true;
  }
}

bool validPassword(String password, String confirmPassword) {
  if (!verifyPassword(password, confirmPassword)) {
    return false;
  }
  return true;
}

Future<String> signInWithUsernameAndPassword(String username, String password) async {
  String email;
  await firestoreInstance.collection("users").where("user_username", isEqualTo: username).get().then((value){
    value.docs.forEach((element) {
      email = element.data()["user_email"].toString();}
    );
  });
  return email;
}

Future<List<String>> getSchools() async {
  List<String> schools = List();
  await firestoreInstance.collection("schools").get().then((value){
    value.docs.forEach((element) {
      schools.add(element.data()["name"].toString());}
    );
  });
  return schools;
}

Future<List<String>> getSchoolLocations() async {
  final String school = await getCurrentSchool();
  CollectionReference userSchool = FirebaseFirestore.instance.collection('schools')
      .doc(school)
      .collection("validLocations");
  List<String> locations = List();
  await userSchool.get().then((value) {
    value.docs.forEach((element) {
      locations.add(element.data()["locationName"].toString());
      print("func: ${element.data()["locationName"]}");
    });
  });
  return locations;
}

Future<List<String>> getEmails(String school) async {
  CollectionReference schools =  FirebaseFirestore.instance.collection('schools')
                                .doc(dropdownValue)
                                .collection("validEmails");

  List<String> emails = List();
  await schools.get().then((value) {
    value.docs.forEach((element) {
      emails.add(element.data()["domain"].toString());
    });
  });
  return emails;
}



void reportPlayer(String uid, String type) async {
  if(type == "Punctuality") {
    await FirebaseFirestore.instance.collection('users').doc(await getDocumentID(uid)).update(<String, dynamic>{'punctualityReport': FieldValue.increment(1)});
  } else {
    await FirebaseFirestore.instance.collection('users').doc(await getDocumentID(uid)).update(<String, dynamic>{'sportsmanshipReport': FieldValue.increment(1)});
  }
}

Future <bool> isManager(String username) async {
  bool verified;
  await firestoreInstance.collection("users").where("user_username", isEqualTo: username).get().then((value){
    value.docs.forEach((element) {
      verified = (element.data()["verified"].toString() == 'true');
      //print("first");
      }
    );
  });

  if (verified != null) return verified;

  //print(username + "Hello.");
  //print("third");

  await firestoreInstance.collection("users").where("user_email", isEqualTo: username).get().then((value){
    value.docs.forEach((element) {
      verified = (element.data()["verified"].toString() == 'true');
      //print("second");
    }
    );
  });

  return verified;
}