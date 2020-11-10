import 'package:cloud_firestore/cloud_firestore.dart';

final firestoreInstance = FirebaseFirestore.instance;

class UserC {
  //I think it's a good idea to separate the User class and their functions so I can add all of the json stuff we need
  String userId;
  String userUsername;
  String userPassword;
  String userEmail;
  bool verified;
  String school;
  String photoURL;

  DocumentReference reference;
  UserC(this.userId, {this.userUsername, this.userPassword, this.userEmail, this.verified, this.school, this.reference, this.photoURL});

  factory UserC.fromJson(Map<dynamic, dynamic> json) => _UserCFromJson(json);

  Map<String, dynamic> toJson() => _UserCToJson(this);
  @override
  String toString() => "User<$userId>";

  //i feel like im in 4th grade making these stupid methods

  void setUsername(String u){
    this.userUsername = u;
  }

  void setPassword(String u){
    this.userPassword = u;
  }

  void setEmail(String u){
    this.userEmail = u;
  }

  void setVerified(bool u){
    this.verified = u;
  }

  void setSchool(String u){
    this.school = u;
  }

  void setPhotoURL(String u) {
    this.photoURL = u;
  }
}

UserC _UserCFromJson(Map<dynamic, dynamic> json){
  return UserC(
    json['user_id'] as String,
    userUsername: json['user_username'] as String,
    userPassword: json['user_password'] as String,
    userEmail: json['user_email'] as String,
    verified: json['verified'] as bool,
    school: json['school'] as String,
    photoURL: json['photoURL'] as String
  );
}

Map<String, dynamic> _UserCToJson(UserC instance) =>
  <String, dynamic> {
      'user_id': instance.userId,
      'user_username': instance.userUsername,
      'user_password': instance.userPassword,
      'user_email': instance.userEmail,
      'verified': instance.verified,
      'school': instance.school,
      'photoURL': instance.photoURL,
  };