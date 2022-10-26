import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hiddplace/utils/alerts.dart';
import 'package:image_picker/image_picker.dart';

class Publications {
  final publicationRef = FirebaseFirestore.instance.collection('publications');
  final photosRef = FirebaseFirestore.instance.collection('publication_photos');
  final DateTime datenow = DateTime.now();

  Future<void> savePublication({
    required String title,
    required String content,
    required List<XFile>? listImages,
    required BuildContext context,
  }) async {
    final userAuth = FirebaseAuth.instance.currentUser;
    final userID = userAuth?.uid;
    String uniqueDocId = DateTime.now().millisecondsSinceEpoch.toString();

    publicationRef.doc(uniqueDocId).set({
      'id': uniqueDocId,
      'title': title,
      'content': content,
      'userID': userID,
      'timestamp': datenow,
    });
    listImages?.forEach((item) => {saveImages(item, uniqueDocId)});
    Alert.alertSucess(context, 'Publicación creada con éxito');
    Navigator.pushNamed(context, 'home');
  }

  void saveImages(XFile image, uniqueDocId) async {
    final userAuth = FirebaseAuth.instance.currentUser;
    final userID = userAuth?.uid;
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirImages = referenceRoot.child('/publications/$userID');
    Reference referenceImagenToUpload = referenceDirImages.child(image.name!);
    String? imageurl;

    //subir imagen a firestorange
    await referenceImagenToUpload.putFile(File(image.path));
    imageurl = await referenceImagenToUpload.getDownloadURL();
    photosRef.add({
      'imageUrl': imageurl,
      'publicationID': uniqueDocId,
      'timestamp': datenow,
    });
  }
}
