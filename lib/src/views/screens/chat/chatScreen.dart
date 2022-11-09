import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../constants.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: kPrimaryColor,
        onPressed: () {
          Navigator.pushNamed(context, 'createPublication');
        },
        child: const FaIcon(
          color: UiColors.white,
          FontAwesomeIcons.solidMessage,
          size: 25,
        ),
      ),
      body: Stack(
        children: const [
          // Positioned.fill(  //
          //   child: Image(
          //     image: AssetImage("assets/images/fondoChat.png"),
          //     fit : BoxFit.cover,
          //   ),
          // ),
          Center(
            child: Text("Hello background"),
          )
        ],
      ),
    );
  }
}
