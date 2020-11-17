import 'package:cloud_firestore/cloud_firestore.dart';

final firestoreInstance = FirebaseFirestore.instance;

class UserC {
  //I think it's a good idea to separate the User class and their functions so I can add all of the json stuff we need
  String userId;
  String userUsername;
  String userPassword;
  String userEmail;
  bool verified;
  bool banned;
  String school;
  String photoURL;
  int sportsmanshipReport;
  int punctualityReport;
  int gamesPlayed;

  DocumentReference reference;
  UserC(this.userId, {this.userUsername, this.userPassword, this.userEmail, this.verified, this.banned, this.school, this.reference, this.photoURL, this.sportsmanshipReport, this.punctualityReport, this.gamesPlayed});

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
    banned: json['banned'] as bool,
    school: json['school'] as String,
    photoURL: json['photoURL'] as String,
    sportsmanshipReport: json['sportsmanshipReport'] as int,
    punctualityReport: json['punctualityReport'] as int,
    gamesPlayed: json['gamesPlayed'] as int
  );
}

Map<String, dynamic> _UserCToJson(UserC instance) =>
  <String, dynamic> {
      'user_id': instance.userId,
      'user_username': instance.userUsername,
      'user_password': instance.userPassword,
      'user_email': instance.userEmail,
      'verified': instance.verified,
      'banned' : instance.banned,
      'school': instance.school,
      'photoURL': instance.photoURL,
      'sportsmanshipReport' : instance.sportsmanshipReport,
      'punctualityReport' : instance.punctualityReport,
      'gamesPlayed' : instance.gamesPlayed,

  };