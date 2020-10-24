import 'dart:async';
import 'package:reservrec/src/file_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:reservrec/src/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

class UserC {
  //I think it's a good idea to separate the User class and their functions so I can add all of the json stuff we need
  int user_id;
  String user_username;
  String user_password;
  String user_email;
  bool verified;
  String school;

  DocumentReference reference;
  UserC(this.user_id, {this.user_username, this.user_password, this.user_email, this.verified, this.school, this.reference});

  factory UserC.fromJson(Map<dynamic, dynamic> json) => _UserCFromJson(json);

  Map<String, dynamic> toJson() => _UserCToJson(this);
  @override
  String toString() => "User<$user_id>";
}

UserC _UserCFromJson(Map<dynamic, dynamic> json){
  return UserC(
    json['user_id'] as int,
    user_username: json['user_username'] as String,
    user_password: json['user_password'] as String,
    user_email: json['user_email'] as String,
    verified: json['verified'] as bool,
    school: json['school'] as String,
  );
}

Map<String, dynamic> _UserCToJson(UserC instance) =>
  <String, dynamic> {
      'user_id': instance.user_id,
      'user_username': instance.user_username,
      'user_password': instance.user_password,
      'user_email': instance.user_email,
      'verified': instance.verified,
      'school': instance.school,
  };