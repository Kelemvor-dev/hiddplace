import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  final String? id;
  final List? users;
  final Map? chat;
  final Timestamp? date;

  ChatModel({
    this.id,
    this.users,
    this.chat,
    this.date,
  });

  Map<String, dynamic> toMap() {
    return {'id': id, 'users': users,'chat': chat, 'timestamp': date};
  }

  ChatModel.fromFirestore(Map<String, dynamic> firestore)
      : id = firestore['id'],
        users = firestore['users'],
        chat = firestore['chat'],
        date = firestore['timestamp'];
}
