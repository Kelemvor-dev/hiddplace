import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/services.dart';
import 'package:hiddplace/constants.dart';
import 'package:hiddplace/src/components/navbar/drawer.dart';
import 'package:hiddplace/src/components/navbar/navbar.dart';
import 'package:hiddplace/src/providers/profile.dart';
import 'package:hiddplace/src/screens/chat/chatScreen.dart';
import 'package:hiddplace/src/screens/login.dart';
import 'package:hiddplace/src/screens/publications/publicationScreen.dart';
import 'package:hiddplace/src/screens/users/profileScreen.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  final userAuth = FirebaseAuth.instance.currentUser;
  final userId = FirebaseAuth.instance.currentUser?.uid;

  late AnimationController animationController;
  Duration animationDuration = const Duration(milliseconds: 270);

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top]);

    animationController =
        AnimationController(vsync: this, duration: animationDuration);
    //Llamamos la informacion del perfil en la base de datos(Firestore) con Provider
    Provider.of<ProfileData>(context, listen: false).getProfile();
  }

  final List<Widget> _tabItems = [
    const ChatScreen(),
    const PublicationScreen(),
    const ProfileScreen()
  ];
  int _page = 1;

  final GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: const Navbar(
          title: "Hiddplace", transparent: false, bgColor: kPrimaryColor),
      drawer: const NowDrawer(currentPage: "Home"),
      body: _tabItems[_page],
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        index: 1,
        height: 60.0,
        items: const <Widget>[
          Icon(
            Icons.chat,
            size: 30,
            color: kSecundaryColor,
          ),
          Icon(
            Icons.home,
            size: 30,
            color: kSecundaryColor,
          ),
          Icon(
            Icons.perm_identity,
            size: 30,
            color: kSecundaryColor,
          ),
        ],
        color: kPrimaryColor,
        buttonBackgroundColor: kPrimaryColor,
        backgroundColor: Colors.white,
        animationCurve: Curves.decelerate,
        animationDuration: const Duration(milliseconds: 600),
        onTap: (index) {
          setState(() {
            _page = index;
          });
        },
        letIndexChange: (index) => true,
      ),
    );
  }
}
