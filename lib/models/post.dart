import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  int postUserId; //foreign key
  int postId;
  String postDescription;
  DateTime postTimePosted;
  DateTime postTimeSet;
  String postSport;
  String postLocation;
  int maxPeople;
  int minPeople;

  //camel case is wack

  DocumentReference reference;
  Post(this.postUserId, this.postId, {this.postDescription, this.postTimePosted, this.postTimeSet, this.postSport, this.postLocation, this.maxPeople, this.minPeople});

  factory Post.fromJson(Map<dynamic, dynamic> json) => _PostFromJson(json);

  Map<String, dynamic> toJson() => _PostToJson(this);
  @override
  String toString() => "Post<$postUserId, $postId>";

  void setUserId(int u){
    this.postUserId = u;
  }

  void setPostId(int u){
    this.postId = u;
  }

  void setDescription(String u){
    this.postDescription = u;
  }

  void setTimePosted(DateTime u){
    this.postTimePosted = u;
  }

  void setTimeSet(DateTime u){
    this.postTimeSet = u;
  }

  void setSport(String u){
    this.postSport = u;
  }

  void setLocation(String u){
    this.postLocation = u;
  }

  void setMaxPeople(int u){
    this.maxPeople = u;
  }

  void setMinPeople(int u){
    this.minPeople = u;
  }
}

Post _PostFromJson(Map<dynamic, dynamic> json){
  var posted = (json["time_posted"] as Timestamp).toDate();
  var set = (json["time_set"] as Timestamp).toDate();

  return Post(
    json["post_id"] as int,
    json["user_id"] as int,
    postDescription: json["description"] as String,
    postTimePosted: posted,
    postTimeSet: set,
    postSport: json["sport"] as String,
    postLocation: json["location"] as String,
    maxPeople: json["max_people"] as int,
    minPeople: json["min_people"] as int,
  );
}

Map<String, dynamic> _PostToJson(Post instance) =>
    <String, dynamic> {
      "user_id": instance.postUserId,
      "post_id": instance.postId,
      "description": instance.postDescription,
      "time_posted": instance.postTimePosted,
      "time_set": instance.postTimeSet,
      "sport": instance.postSport,
      "location": instance.postLocation,
      "max_people": instance.maxPeople,
      "min_people": instance.minPeople,
    };