import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hiddplace/constants.dart';

class PublicationScreen extends StatelessWidget {
  const PublicationScreen({super.key});

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
          FontAwesomeIcons.circlePlus,
          size: 35,
        ),
      ),
      body: const Text("Publicaciones"),
    );
  }
}
