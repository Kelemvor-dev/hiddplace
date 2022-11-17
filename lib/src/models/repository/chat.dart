import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../entity/chat.dart';

class Chat {
  final chatRef = FirebaseFirestore.instance.collection('chat');
  final DateTime datenow = DateTime.now();
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<QuerySnapshot<Map<String, dynamic>>> getChatByUserID(userID) {
    var list = _db.collection('chat').where('users', arrayContains: userID).orderBy('timestamp', descending: true).snapshots();
    return list;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getChatByID(id) {
    var list = _db.collection('chat').where('id', isEqualTo: id).orderBy('timestamp', descending: true).snapshots();
    return list;
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getUserChatByID(userID) {
    var list = _db.collection('users').where("id", isEqualTo: userID).snapshots();
    return list;
  }

  Future saveChat({
    required String? userID,
    required String? followedID,
    required String? comment,
    required String? imageUrl,
    required BuildContext context,
  }) async {
    String uniqueDocId = DateTime.now().millisecondsSinceEpoch.toString();
    List<String> users = [];
    List<Map> chat = [];
    users.add(userID!);
    users.add(followedID!);
    Map talks = {
      'userID':userID,
      'imageUrl': imageUrl,
      'comment': comment,
      'timestamp': datenow,
    };
    chat.add(talks);
    chatRef.doc(uniqueDocId).set({
      'id': uniqueDocId,
      'users': users,
      'chat': chat,
      'timestamp': datenow,
    });
  }

  Future saveTalkChat({
    required String? id,
    required String? comment,
    required String userID,
    required String? imageUrl,
    required List<dynamic>? chat,
    required BuildContext context,
  }) async {
    Map updatechat = {
      'userID': userID,
      'imageUrl': imageUrl,
      'comment': comment,
      'timestamp': datenow,
    };
    chat?.add(updatechat);
    chatRef.doc(id).update({
      'chat': chat,
    });
  }

  Future deleteChat({
    required String? id,
    required BuildContext context,
  }) async {
    chatRef
        .doc(id) // <-- Doc ID to be deleted.
        .delete() // <-- Delete
        .then((_) => {})
        .catchError((error) => print('Delete failed: $error'));
  }

  getUsersChat(userID) {
    return _db.collection('chat').where('users', arrayContains: userID).orderBy('timestamp', descending: true).get();
  }
}
