import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  //maybe include picture haven't decided yet
  int user_id;
  String user_username;
  String user_password;
  String user_email;
  bool verified;
  String school;

  DocumentReference reference;
  User(this.user_id, {this.user_username, this.user_password, this.user_email, this.verified, this.school, this.reference});

  factory User.fromJson(Map<dynamic, dynamic> json) => _UserFromJson(json);

  Map<String, dynamic> toJson() => _UserToJson(this);
  @override
  String toString() => "User<$user_id>";
}

User _UserFromJson(Map<dynamic, dynamic> json){
  return User(
    json['user_id'] as int,
    user_username: json['user_username'] as String,
    user_password: json['user_password'] as String,
    user_email: json['user_email'] as String,
    verified: json['verified'] as bool,
    school: json['school'] as String,
  );
}

Map<String, dynamic> _UserToJson(User instance) =>
  <String, dynamic> {
      'user_id': instance.user_id,
      'user_username': instance.user_username,
      'user_password': instance.user_password,
      'user_email': instance.user_email,
      'verified': instance.verified,
      'school': instance.school,
  };