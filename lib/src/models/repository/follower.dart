import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../entity/followers.dart';

class Follower {
  final followRef = FirebaseFirestore.instance.collection('followers');
  final DateTime datenow = DateTime.now();
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> follow({
    required String userID,
    required String followedID,
    required Map user,
  }) async {
    String uniqueDocId = DateTime.now().millisecondsSinceEpoch.toString();

    followRef.doc(uniqueDocId).set({
      'id': uniqueDocId,
      'userID': userID,
      'followedID': followedID,
      'user': user,
      'timestamp': datenow,
    });
  }

  Future<void> unfollow({
    required String? followID,
  }) async {
    followRef
        .doc(followID) // <-- Doc ID to be deleted.
        .delete() // <-- Delete
        .then((_) => {})
        .catchError((error) => print('Delete failed: $error'));
  }

  Stream<List<FollowersModel>> getFollowers() {
    var list = _db
        .collection('followers')
        .where("userID", isEqualTo: _auth.currentUser?.uid)
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((document) => FollowersModel.fromFirestore(document.data())).toList());
    return list;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getFollowersByID(userID) {
    return _db.collection('followers').where("userID", isEqualTo: userID).orderBy('timestamp', descending: true).snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getfollowedsByID(userID) {
    return _db.collection('followers').where("followedID", isEqualTo: userID).orderBy('timestamp', descending: true).snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getfollowedsByIDAndUserID(userID, followedID) {
    return _db
        .collection('followers')
        .where("followedID", isEqualTo: followedID)
        .where("userID", isEqualTo: userID)
        .orderBy('timestamp', descending: true)
        .snapshots();
  }
}
