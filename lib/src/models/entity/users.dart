import 'package:cloud_firestore/cloud_firestore.dart';

class UsersModel {
  final String? id;
  final String? name;
  final String? lastname;
  final String? email;
  final String? phone;
  final String? photoUrl;
  final Timestamp? date;

  UsersModel({
    this.id,
    this.name,
    this.lastname,
    this.email,
    this.phone,
    this.photoUrl,
    this.date,
  });

  Map<String, dynamic> toMap() {
    return {'id': id, 'name': name,'lastname': lastname,'email': email,'phone': phone,'photoUrl': photoUrl, 'timestamp': date};
  }

  UsersModel.fromFirestore(Map<String, dynamic> firestore)
      : id = firestore['id'],
        name = firestore['name'],
        lastname = firestore['lastname'],
        email = firestore['email'],
        phone = firestore['phone'],
        photoUrl = firestore['photoUrl'],
        date = firestore['timestamp'];
}
