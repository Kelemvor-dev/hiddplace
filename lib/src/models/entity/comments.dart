import 'package:cloud_firestore/cloud_firestore.dart';

class CommentsModel {
  final String? id;
  final String? userID;
  final String? publicationID;
  final Map? user;
  final String? comment;
  final List? likes;
  final Timestamp? date;

  CommentsModel({
    this.id,
    this.userID,
    this.publicationID,
    this.user,
    this.comment,
    this.likes,
    this.date,
  });

  Map<String, dynamic> toMap() {
    return {'id': id, 'userID': userID, 'publicationID': publicationID, 'user': user, 'comment': comment, 'likes': likes, 'timestamp': date};
  }

  CommentsModel.fromFirestore(Map<String, dynamic> firestore)
      : id = firestore['id'],
        userID = firestore['userID'],
        publicationID = firestore['publicationID'],
        user = firestore['user'],
        comment = firestore['comment'],
        likes = firestore['likes'],
        date = firestore['timestamp'];
}
