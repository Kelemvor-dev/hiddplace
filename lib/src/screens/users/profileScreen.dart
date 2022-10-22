import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hiddplace/constants.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileState();
}

class _ProfileState extends State<ProfileScreen>{
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? _uid;
  String? _name;
  String? _lastname;
  String? _photoUrl;

  void getData() async {
    User user = _auth.currentUser!;
    _uid = user.uid;
    final DocumentSnapshot userDoc =
    await FirebaseFirestore.instance.collection('users').doc(_uid).get();
    _name = userDoc.get('name');
    _lastname = userDoc.get('lastname');
    _photoUrl = userDoc.get('photoUrl');
    setState((){});
  }

  @override
  void initState() {
    super.initState();
    getData();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Flexible(
                flex: 1,
                child: Container(
                    height: 284,
                    decoration: const BoxDecoration(
                        // image: DecorationImage(
                        //     image: AssetImage("assets/imgs/bg-profile.png"),
                        //     fit: BoxFit.cover),
                        color: kPrimaryColor),
                    child: Stack(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 70, right: 0),
                          child: Column(
                            children: [
                              CircleAvatar(
                                  backgroundImage:
                                      NetworkImage(_photoUrl ?? ''),
                                  radius: 65.0),
                              Padding(
                                padding: const EdgeInsets.only(top: 24.0),
                                child: Text('$_name $_lastname' ?? '',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 22)),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 24.0, left: 42, right: 32),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisSize: MainAxisSize.max,
                                  //Si quiero agregar mas cosas dentro del perfil children: [],
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    )),
              ),
              Flexible(
                flex: 1,
                child: Container(
                    child: SingleChildScrollView(
                        child: Padding(
                  padding:
                      const EdgeInsets.only(left: 32.0, right: 32.0, top: 42.0),
                  child: Column(
                      // Aqui van las publicaciones
                      children: const [Text("Publicaciones")]),
                ))),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
