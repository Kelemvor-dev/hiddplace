import 'package:cloud_firestore/cloud_firestore.dart';
import '../entity/users.dart';

class UserProfile {
  final DateTime datenow = DateTime.now();
  final FirebaseFirestore _db = FirebaseFirestore.instance;


  Stream<List<UsersModel>> getUserByID(userID) {
    var list = _db
        .collection('users')
        .where("id", isEqualTo: userID)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((document) => UsersModel.fromFirestore(document.data())).toList());
    return list;
  }

}
