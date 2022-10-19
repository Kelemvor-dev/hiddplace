import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hiddplace/constants.dart';
import 'package:hiddplace/src/components/navbar/drawer.dart';
import 'package:hiddplace/src/components/navbar/navbar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

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
                              const CircleAvatar(
                                  backgroundImage: AssetImage(
                                      "assets/imgs/profile-img.jpg"),
                                  radius: 65.0),
                              const Padding(
                                padding: EdgeInsets.only(top: 24.0),
                                child: Text("Ryan Scheinder",
                                    style: TextStyle(
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
                                  crossAxisAlignment:
                                  CrossAxisAlignment.end,
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
                          padding: const EdgeInsets.only(
                              left: 32.0, right: 32.0, top: 42.0),
                          child: Column(
                              // Aqui van las publicaciones 
                            children: const [
                              Text("Publicaciones")
                            ]
                          ),
                        ))),
              ),
            ],
          ),
        ],
      ),
    );
  }
}