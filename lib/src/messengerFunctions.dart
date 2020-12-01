import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:reservrec/src/user_functions.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final reference = FirebaseFirestore.instance;

class MessageModel {
  final String id;
  final DateTime timeSent;
  final String message;

  const MessageModel({
    this.id,
    this.timeSent,
    this.message
  });

  factory MessageModel.fromJson(Map<dynamic, dynamic> json) => _MessageFromJson(json);
  Map<String, dynamic> toJson() => _MessageToJson(this);

}

MessageModel _MessageFromJson(Map<dynamic, dynamic> json) {
  var posted = (json["timesent"] as Timestamp).toDate();

  return MessageModel(
    id: json["uid"] as String,
    timeSent: posted,
    message: json["message"] as String
  );
}
Map<String, dynamic> _MessageToJson(MessageModel instance) =>
<String, dynamic> {
  "message": instance.message,
  "timesent": instance.timeSent,
  "uid": instance.id,
};

Future<String> getChatInfo(final uid) async {
  final username = await getCurrentUsername(uid);
  final isMan = await isManager(username.toString());
  if(isMan){
    return username + " [Admin]";
  }
  else {
    return username;
  }
}

Future<List<MessageModel>> loadMessages(final gameId) async {
  final CollectionReference messageCollection = reference.collection('posts').doc(gameId.toString()).collection("chat");
  final QuerySnapshot snapshot = await messageCollection.orderBy('timesent', descending: false).get();

  List<MessageModel> messages = List();

  snapshot.docs.forEach((document) async {
    messages.add(MessageModel.fromJson(document.data()));
  });

  return messages;
}

void sendMessage(chatController, final gameId) async {
  final CollectionReference messageCollection = reference.collection('posts').doc(gameId.toString()).collection("chat");
  var m = chatController.text;
  if (m.toString().isEmpty) {
    return;
  }
  var newMessage = MessageModel(id:_auth.currentUser.uid,timeSent:DateTime.now(),message:m.toString());
  await messageCollection.add(newMessage.toJson());
  print(m);
}