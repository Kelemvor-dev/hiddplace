import 'package:cloud_firestore/cloud_firestore.dart';

class FollowersModel {
  final String? id;
  final String? userID;
  final String? followedID;
  final Map? user;
  final Timestamp? date;

  FollowersModel({
    this.id,
    this.userID,
    this.followedID,
    this.user,
    this.date,
  });

  Map<String, dynamic> toMap() {
    return {'id': id, 'userID': userID, 'publicationID': followedID, 'user': user, 'timestamp': date};
  }

  FollowersModel.fromFirestore(Map<String, dynamic> firestore)
      : id = firestore['id'],
        userID = firestore['userID'],
        followedID = firestore['followedID'],
        user = firestore['user'],
        date = firestore['timestamp'];
}
