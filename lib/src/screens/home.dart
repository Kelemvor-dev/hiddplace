import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hiddplace/src/screens/login.dart';

class Home extends StatelessWidget {
  Home({super.key});

  final auth = FirebaseAuth.instance;
  final userAuth = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        Center(
          child: FloatingActionButton(
            child: Text("Cerrar"),
            onPressed: () {
              auth.signOut();
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => const Login()));
            },
          ),
        ),
        Center(
          child: Text("Usuario id: ${userAuth?.uid}"),
        )
      ]),
    );
  }
}
