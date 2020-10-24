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

  //factory User.fromJson(Map<dynamic, dynamic> json) => _UserFromJson(json);

  //Map<String, dynamic> toJson() => _UserToJson(this);
  @override
  String toString() => "User<$user_id>";
}