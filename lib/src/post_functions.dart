import 'dart:async';
import 'package:reservrec/src/feed_functions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;

Future<bool> isInPost(int pid) async {
  final DocumentReference isIn = FirebaseFirestore.instance.collection('posts').doc(await getDocumentID(pid)).collection('cur_users').doc(_auth.currentUser.uid);
  final DocumentSnapshot ss = await isIn.get();
  if(ss.data() == null) {
    return false;
  }
  return true;
}

void changeJoinedStatus(int pid) async {
  if(await isInPost(pid)) {
    await FirebaseFirestore.instance.collection('posts').doc(await getDocumentID(pid)).collection('cur_users').doc(_auth.currentUser.uid).delete();
    await FirebaseFirestore.instance.collection('posts').doc(await getDocumentID(pid)).update(<String, dynamic>{'cur_people': FieldValue.increment(-1)});
  } else {
    await FirebaseFirestore.instance.collection('posts').doc(await getDocumentID(pid)).collection('cur_users').doc(_auth.currentUser.uid).set({});
    await FirebaseFirestore.instance.collection('posts').doc(await getDocumentID(pid)).update(<String, dynamic>{'cur_people': FieldValue.increment(1)});
  }
}

