import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hiddplace/src/models/publications.dart';
import 'package:hiddplace/src/models/publicationsUser.dart';
import 'package:hiddplace/src/providers/profile.dart';
import 'package:hiddplace/utils/alerts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class Publications {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final publicationRef = FirebaseFirestore.instance.collection('publications');
  final photosRef = FirebaseFirestore.instance.collection('publication_photos');
  final DateTime datenow = DateTime.now();
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Stream<List<Publication>> getPublications() {
    var list = _db
        .collection('publications')
        .orderBy('timestamp', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((document) => Publication.fromFirestore(document.data())).toList());
    return list;
  }

  Stream<List<PublicationUser>> getPublicationsByUserID() {
    var list = _db
        .collection('publications')
        .where("userID", isEqualTo: _auth.currentUser?.uid)
        .orderBy('timestamp')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((document) => PublicationUser.fromFirestore(document.data())).toList());
    return list;
  }

  Future<void> savePublication({
    required String title,
    required String content,
    required List<XFile>? listImages,
    required BuildContext context,
  }) async {
    final userAuth = FirebaseAuth.instance.currentUser;
    final userID = userAuth?.uid;
    String uniqueDocId = DateTime.now().millisecondsSinceEpoch.toString();
    String imageurl;
    List<String> images = [];
    Map user = {};
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child('/publications/$userID/$uniqueDocId');
    Reference referenceImagenToUpload;

    for (var i = 0; i < listImages!.length; i++) {
      referenceImagenToUpload = referenceDirImages.child(listImages[i].name!);
      String? imageurl;
      //subir imagen a firestorange
      await referenceImagenToUpload.putFile(File(listImages[i].path));
      imageurl = await referenceImagenToUpload.getDownloadURL();
      images.add(imageurl);
    }
    user = {
      'id': userID,
      'name': Provider.of<ProfileData>(context, listen: false).name,
      'lastname': Provider.of<ProfileData>(context, listen: false).lastname,
      'imageUrl': Provider.of<ProfileData>(context, listen: false).photoUrl
    };

    publicationRef.doc(uniqueDocId).set({
      'id': uniqueDocId,
      'title': title,
      'content': content,
      'images': images,
      'userID': userID,
      'user': user,
      'timestamp': datenow,
    });
    Alert.alertSucess(context, 'Publicación creada con éxito');
    Navigator.pushNamedAndRemoveUntil(context,'home', (Route<dynamic> route) => false);
  }

  deletePublication(context, userID, id) {
    publicationRef
        .doc(id) // <-- Doc ID to be deleted.
        .delete() // <-- Delete
        .then((_) => {
          deleteFolder(userID, id),
          Alert.alertSucess(context, 'Se elimino la publicación correctamente')
        })
        .catchError((error) => print('Delete failed: $error'));

  }

  void deleteFolder(userID, id){
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child('/publications/$userID/$id');
    referenceDirImages.listAll().then((value) => {
      value.items.forEach((element) {
        FirebaseStorage.instance.ref(element.fullPath).delete();
      })
    });
  }
}
