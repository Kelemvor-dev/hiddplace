import 'package:cloud_firestore/cloud_firestore.dart';

class PublicationUser {
  final String? id;
  final String? title;
  final String? content;
  final List? images;
  final Map? user;
  final String? userID;
  final List? likes;
  final Timestamp? date;

  PublicationUser({
    this.id,
    this.title,
    this.content,
    this.images,
    this.user,
    this.userID,
    this.likes,
    this.date,
  });

  Map<String, dynamic> toMap() {
    return {'id': id, 'title': title, 'content': content, 'images': images, 'user': user, 'userID': userID, 'likes': likes, 'timestamp': date};
  }

  PublicationUser.fromFirestore(Map<String, dynamic>? firestore)
      : id = firestore!['id'],
        title = firestore!['title'],
        content = firestore!['content'],
        images = firestore!['images'],
        user = firestore!['user'],
        userID = firestore!['userID'],
        likes = firestore!['likes'],
        date = firestore!['timestamp'];
}
