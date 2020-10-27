import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reservrec/models/user.dart';

//Top level collection of users will be called 'user'

class DataRepository {

  final CollectionReference collection = FirebaseFirestore.instance.collection('users');

  //the following "querysnapshot" gets real time updates. found this on a stack overflow webpage

  Stream<QuerySnapshot> getStream() {
    return collection.snapshots();
  }

  Future<DocumentReference> addUserC(UserC userc) {
    return collection.add(userc.toJson());
  }

  updateUser(UserC userc) async {
    await collection.doc(userc.reference.id).update(userc.toJson());
  }
}