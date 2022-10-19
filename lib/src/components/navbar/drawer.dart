import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hiddplace/constants.dart';
import 'package:hiddplace/src/components/navbar/drawer-tile.dart';
import 'package:hiddplace/src/screens/login.dart';


class NowDrawer extends StatelessWidget {
  final String currentPage;


  const NowDrawer({super.key, required this.currentPage});

  

  @override
  Widget build(BuildContext context) {
    final auth = FirebaseAuth.instance;
    return Drawer(
        child: Container(
      color: UiColors.primary,
      child: Column(children: [
        SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width * 0.85,
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.only(left: 24.0, right: 20.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text(
                      'Hiddplace',
                      style: GoogleFonts.pacifico(
                          textStyle: Theme.of(context).textTheme.headline4,
                          fontSize: 24,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.italic,
                          color: UiColors.white),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: IconButton(
                          icon: Icon(Icons.menu,
                              color: UiColors.white.withOpacity(0.82),
                              size: 24.0),
                          onPressed: () {
                            Navigator.of(context).pop();
                          }),
                    ),
                  ],
                ),
              ),
            )),
        Expanded(
          flex: 2,
          child: ListView(
            padding: const EdgeInsets.only(top: 36, left: 8, right: 16),
            children: [
              DrawerTile(
                  icon: FontAwesomeIcons.house,
                  onTap: () {
                    if (currentPage != "Home") {
                      auth.signOut();
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (context) => const Login()));
                    }
                  },
                  iconColor: UiColors.white,
                  title: "Home",
                  isSelected: currentPage == "Home" ? true : false),
              DrawerTile(
                  icon: FontAwesomeIcons.user,
                  onTap: () {
                    if (currentPage != "Profile") {
                      Navigator.pushReplacementNamed(context, '/profile');
                    }
                  },
                  iconColor: UiColors.warning,
                  title: "Editar Perfil",
                  isSelected: currentPage == "Profile" ? true : false),

            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(
              padding: const EdgeInsets.only(left: 8, right: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Divider(
                      height: 4,
                      thickness: 0,
                      color: UiColors.white.withOpacity(0.8)),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 16.0, left: 16, bottom: 8),
                    child: Text("CONFIGURACIONES",
                        style: TextStyle(
                          color: UiColors.white.withOpacity(0.8),
                          fontSize: 13,
                        )),
                  ),
                  DrawerTile(
                      icon: FontAwesomeIcons.powerOff,
                      onTap: (){
                        auth.signOut();
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (context) => const Login()));
                      },
                      iconColor: UiColors.muted,
                      title: "Cerrar sesión",
                      isSelected:
                          currentPage == "Getting started" ? true : false),
                ],
              )),
        ),
      ]),
    ));
  }
}
