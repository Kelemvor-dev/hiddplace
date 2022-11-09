import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileData with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String _uid = '';
  String _name = '';
  String _lastname = '';
  String _phone = '';

  String get phone => _phone;

  set phone(String value) {
    _phone = value;
    notifyListeners();
  }

  String _photoUrl = '';

  Future getProfile() async {
    User user = _auth.currentUser!;
    _uid = user.uid;
    final DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(_uid).get();
    _name = userDoc.get('name');
    _lastname = userDoc.get('lastname');
    _phone = userDoc.get('phone');
    _photoUrl = userDoc.get('photoUrl');
  }

  Future getProfileByID(userID) async {
    Map user = {};
    final DocumentSnapshot userDoc =
    await FirebaseFirestore.instance.collection('users').doc(userID).get();
    user = {
      'userID': userID,
      'name': userDoc.get('name'),
      'lastname': userDoc.get('lastname'),
      'imageUrl': userDoc.get('photoUrl'),
    };
    return user;
  }

  String get name => _name;

  set name(String value) {
    _name = value;
    notifyListeners();
  }

  String get lastname => _lastname;

  set lastname(String value) {
    _lastname = value;
    notifyListeners();
  }

  String get photoUrl => _photoUrl;

  set photoUrl(String value) {
    _photoUrl = value;
    notifyListeners();
  }

  void removeProfileData() {
    _uid = "";
    _name = "";
    _lastname = "";
    _photoUrl = "";
    notifyListeners();
  }
}
