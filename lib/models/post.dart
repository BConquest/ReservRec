import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  int post_user_id; //foreign key
  int post_id;
  String post_description;
  DateTime post_time_posted;
  DateTime post_time_set;
  String post_sport;
  String post_location;
  int max_people;
  int min_people;

  //camel case is wack

  DocumentReference reference;
  Post(this.post_user_id, this.post_id, {this.post_description, this.post_time_posted, this.post_time_set, this.post_sport, this.post_location, this.max_people, this.min_people});

  factory Post.fromJson(Map<dynamic, dynamic> json) => _PostFromJson(json);

  Map<String, dynamic> toJson() => _PostToJson(this);
  @override
  String toString() => "Post<$post_user_id, $post_id>";
}

Post _PostFromJson(Map<dynamic, dynamic> json){
  return Post(
    json['post_user_id'] as int,
    json['post_id'] as int,
    post_description: ['post_description'] as String,
    post_time_posted: ['post_time_posted'] as DateTime,
    post_time_set: ['post_time_set'] as DateTime,
    post_sport: ['post_sport'] as String,
    post_location: ['post_location'] as String,
    max_people: ['max_people'] as int,
    min_people: ['min_people'] as int,
  );
}

Map<String, dynamic> _PostToJson(Post instance) =>
    <String, dynamic> {
      'post_user_id': instance.post_user_id,
      'post_id': instance.post_id,
      'post_description': instance.post_description,
      'post_time_posted': instance.post_time_posted,
      'post_time_set': instance.post_time_set,
      'post_sport': instance.post_sport,
      'post_location': instance.post_location,
      'max_people': instance.max_people,
      'min_people': instance.min_people,
    };