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

  void setUserId(int u){
    this.post_user_id = u;
  }

  void setPostId(int u){
    this.post_id = u;
  }

  void setDescription(String u){
    this.post_description = u;
  }

  void setTimePosted(DateTime u){
    this.post_time_posted = u;
  }

  void setTimeSet(DateTime u){
    this.post_time_set = u;
  }

  void setSport(String u){
    this.post_sport = u;
  }

  void setLocation(String u){
    this.post_location = u;
  }

  void setMaxPeople(int u){
    this.max_people = u;
  }

  void setMinPeople(int u){
    this.min_people = u;
  }
}

Post _PostFromJson(Map<dynamic, dynamic> json){
  var posted = (json['time_posted'] as Timestamp).toDate();
  var set = (json['time_set'] as Timestamp).toDate();

  return Post(
    json['post_id'] as int,
    json['user_id'] as int,
    post_description: json['description'] as String,
    post_time_posted: posted,
    post_time_set: set,
    post_sport: json['sport'] as String,
    post_location: json['location'] as String,
    max_people: json['max_people'] as int,
    min_people: json['min_people'] as int,
  );
}

Map<String, dynamic> _PostToJson(Post instance) =>
    <String, dynamic> {
      'user_id': instance.post_user_id,
      'post_id': instance.post_id,
      'description': instance.post_description,
      'time_posted': instance.post_time_posted,
      'time_set': instance.post_time_set,
      'sport': instance.post_sport,
      'location': instance.post_location,
      'max_people': instance.max_people,
      'min_people': instance.min_people,
    };