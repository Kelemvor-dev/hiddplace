import 'package:cloud_firestore/cloud_firestore.dart';

class Publication {
  final String? id;
  final String? title;
  final String? content;
  final List? images;
  final Map? user;
  final String? userID;
  final Timestamp? date;

  Publication({
    this.id,
    this.title,
    this.content,
    this.images,
    this.user,
    this.userID,
    this.date,
  });

  Map<String, dynamic> toMap() {
    return {'id': id, 'title': title, 'content': content, 'images': images, 'user': user,'userID':userID, 'timestamp': date};
  }

  Publication.fromFirestore(Map<String, dynamic> firestore)
      : id = firestore['id'],
        title = firestore['title'],
        content = firestore['content'],
        images = firestore['images'],
        user = firestore['user'],
        userID = firestore['userID'],
        date = firestore['timestamp'];
}
