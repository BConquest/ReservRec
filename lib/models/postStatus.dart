import 'package:cloud_firestore/cloud_firestore.dart';

class PostStatus {
  int post_id; //foreign key
  String status;

  DocumentReference reference;
  PostStatus(this.post_id, this.status);

  factory PostStatus.fromJson(Map<dynamic, dynamic> json) => _PostStatusFromJson(json);

  Map<String, dynamic> toJson() => _PostStatusToJson(this);
  @override
  String toString() => "PostStatus<$post_id>";
}

PostStatus _PostStatusFromJson(Map<dynamic, dynamic> json){
  return PostStatus(
    json['post_id'] as int,
    json['status'] as String,
  );
}

Map<String, dynamic> _PostStatusToJson(PostStatus instance) =>
    <String, dynamic> {
      'post_id': instance.post_id,
      'status': instance.status,
    };