import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hiddplace/src/providers/profile.dart';
import 'package:hiddplace/src/screens/home.dart';
import 'package:hiddplace/utils/showSnackbar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../utils/alerts.dart';

class FirebaseAuthMethods {
  //Firebase auth instance
  final FirebaseAuth _auth;
  final usersRef = FirebaseFirestore.instance.collection('users');
  final auth = FirebaseAuth.instance;
  final DateTime timestamp = DateTime.now();

  FirebaseAuthMethods(this._auth);

  User? get user => _auth.currentUser;

  // STATE PERSISTENCE STREAM
  Stream<User?> get authState => FirebaseAuth.instance.authStateChanges();

  // OTRAS FORMAS (depende del caso de uso):
  // Stream get authState => FirebaseAuth.instance.userChanges();
  // Stream get authState => FirebaseAuth.instance.idTokenChanges();
  // CONOCE MÁS SOBRE ELLOS AQUÍ: https://firebase.flutter.dev/docs/auth/start#auth-state

  // Registro de usuarios con email y contraseña
  Future<void> signUpWithEmail({
    required String name,
    required String lastname,
    required String phone,
    required List<XFile>? imageUrl,
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await saveFirestoreProfile(context, name, lastname, phone, imageUrl, email);
      Navigator.pushNamed(context, 'home');
    } on FirebaseAuthException catch (e) {
      // if you want to display your own custom error message
      if (e.code == 'weak-password') {
        Alert.alertAuth(context, "La contraseña proporcionada es demasiado débil.");
      } else if (e.code == 'email-already-in-use') {
        Alert.alertAuth(context, "Este email ya se encuentra en uso.");
      } else if (e.code == 'unknown') {
        Alert.alertAuth(context, "Alguno de los campos esta vacio.");
      }
      if (e.code != 'weak-password' && e.code != 'email-already-in-use' && e.code != 'unknown') {
        print(e.code);
        Alert.alertAuth(context, e.message);
        // showSnackBar(context, e.message!);
      }
    }
  }

  Future<void> editProfile({
    required String name,
    required String lastname,
    required String phone,
    required List<XFile>? imageUrl,
    required BuildContext context,
  }) async {
    await editFirestoreProfile(context, name, lastname, phone, imageUrl);
    Alert.alertSucess(context, 'Datos guardados con exito');
  }

  String imageurl = "";
  // Login con email y contraseña
  Future<void> loginWithEmail({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // if (!user.emailVerified) {
      //   await sendEmailVerification(context);
      // }
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Home()),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'unknown') {
        Alert.alertAuth(context, "Alguno de los campos esta vacio.");
      } else if (e.code == 'user-not-found') {
        Alert.alertAuth(context, 'Este usuario no se encuentra en nuestro sistema.');
      } else if (e.code == 'invalid-email') {
        Alert.alertAuth(context, 'El E-mail es invalido.');
      } else if (e.code == 'wrong-password') {
        Alert.alertAuth(context, 'La contraseña es invalida.');
      }
      if (e.code != 'unknown' && e.code != 'user-not-found' && e.code != 'invalid-email' && e.code != 'wrong-password') {
        print(e.code);
        Alert.alertAuth(context, e.message);
        // showSnackBar(context, e.message!);
      }
    }
  }

  // Verificacion de email
  Future<void> sendEmailVerification(BuildContext context) async {
    try {
      _auth.currentUser?.sendEmailVerification();
      showSnackBar(context, 'Email verification sent!');
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!); // Display error message
    }
  }

  //Editar Perfil en base de datos

  Future<void> editFirestoreProfile(BuildContext context, String name, String lastname, String phone, List<XFile>? imageUrl) async {
    final userAuth = FirebaseAuth.instance.currentUser;
    final userID = userAuth?.uid;
    final DocumentSnapshot doc = await usersRef.doc(userAuth?.uid).get();
    String? imageurl;
    print("Imagen seleccionada: ${imageUrl?[0].name}");
    //Instancia FireStorange
    if (imageUrl?[0].name != null) {
      String? nameImage = imageUrl?[0].name;
      Reference referenceRoot = FirebaseStorage.instance.ref();
      Reference referenceDirImages = referenceRoot.child('/users/$userID');
      Reference referenceImagenToUpload = referenceDirImages.child(nameImage!);
      //subir imagen a firestorange
      try {
        await referenceImagenToUpload.putFile(File(imageUrl![0].path));
        imageurl = await referenceImagenToUpload.getDownloadURL();
      } on FirebaseException catch (e) {
        print(e.message);
      }
    }
    if (imageurl != null) {
      usersRef.doc(userAuth?.uid).update({
        'id': userAuth?.uid,
        'name': name,
        'lastname': lastname,
        'phone': phone,
        'photoUrl': imageurl,
        'timestamp': timestamp,
      });
    } else {
      usersRef.doc(userAuth?.uid).update({
        'id': userAuth?.uid,
        'name': name,
        'lastname': lastname,
        'phone': phone,
        'timestamp': timestamp,
      });
    }
  }

  //Crear perfil en Base de datos

  Future<void> saveFirestoreProfile(BuildContext context, String name, String lastname, String phone, List<XFile>? imageUrl, String email) async {
    final userAuth = FirebaseAuth.instance.currentUser;
    final userID = userAuth?.uid;
    final DocumentSnapshot doc = await usersRef.doc(userAuth?.uid).get();
    String? imageurl;
    if (imageUrl?[0].name != null) {
      String? nameImage = imageUrl?[0].name;
      //Instancia FireStorange
      Reference referenceRoot = FirebaseStorage.instance.ref();
      Reference referenceDirImages = referenceRoot.child('/users/$userID');
      Reference referenceImagenToUpload = referenceDirImages.child(nameImage!);
      //subir imagen a firestorange
      try {
        await referenceImagenToUpload.putFile(File(imageUrl![0].path));
        imageurl = await referenceImagenToUpload.getDownloadURL();
      } on FirebaseException catch (e) {
        print(e.message);
      }
    }
    if (!doc.exists) {
      usersRef.doc(userAuth?.uid).set({
        'id': userAuth?.uid,
        'name': name,
        'lastname': lastname,
        'email': email,
        'phone': phone,
        'photoUrl': imageurl,
        'timestamp': timestamp,
      });
    }
  }

  // Inicio de sesion con google
  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      if (kIsWeb) {
        GoogleAuthProvider googleProvider = GoogleAuthProvider();

        googleProvider.addScope('https://www.googleapis.com/auth/contacts.readonly');

        await _auth.signInWithPopup(googleProvider);
      } else {
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

        final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

        if (googleAuth?.accessToken != null && googleAuth?.idToken != null) {
          // Create a new credential
          final credential = GoogleAuthProvider.credential(
            accessToken: googleAuth?.accessToken,
            idToken: googleAuth?.idToken,
          );
          UserCredential userCredential = await _auth.signInWithCredential(credential);

          // si desea realizar una tarea específica, como almacenar información en firestore
          // solo para nuevos usuarios que usen el inicio de sesión de Google (ya que no hay dos opciones
          // para el inicio de sesión de Google y el registro de Google, solo uno a partir de ahora),
          // Haz lo siguiente:

          // if (userCredential.user != null) {
          //   if (userCredential.additionalUserInfo!.isNewUser) {}
          // }
        }
      }
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!); // Displaying the error message
    }
  }

  // Cerrar sesion
  Future<void> signOut(BuildContext context) async {
    try {
      await _auth.signOut();
      Provider.of<ProfileData>(context, listen: false).removeProfileData();
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!); // Displaying the error message
    }
  }

  // Eliminar cuanta el usuario debe estar logueado
  Future<void> deleteAccount(BuildContext context) async {
    try {
      await _auth.currentUser!.delete();
    } on FirebaseAuthException catch (e) {
      showSnackBar(context, e.message!);
    }
  }
}
