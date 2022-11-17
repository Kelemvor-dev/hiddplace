import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hiddplace/src/controllers/chatController.dart';
import 'package:hiddplace/src/models/repository/users.dart';
import 'package:provider/provider.dart';

import '../../../../constants.dart';
import '../../../../utils/cachedNetworkImage.dart';
import '../../../models/providers/profile.dart';
import '../../components/navbar/popNavbar.dart';

class NewTalkScreen extends StatefulWidget {
  const NewTalkScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<NewTalkScreen> createState() => _NewTalkScreenState();
}

class _NewTalkScreenState extends State<NewTalkScreen> {
  final TextEditingController commentController = TextEditingController();
  final userId = FirebaseAuth.instance.currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    Object? followedID = ModalRoute.of(context)?.settings.arguments;
    return StreamBuilder(
        stream: UserProfile().getUserByID(followedID),
        builder: (context, userProfile) {
          return Scaffold(
            appBar: PopNavbar(
              title: "${userProfile.data?.first.name} ${userProfile.data?.first.lastname}",
              transparent: false,
              bgColor: kPrimaryColor,
              fontsize: 14,
              imageUrl: userProfile.data?.first.photoUrl,
            ),
            bottomNavigationBar: Transform.translate(
              offset: Offset(0.0, -1 * MediaQuery.of(context).viewInsets.bottom),
              child: Container(
                height: 80.0,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      offset: Offset(0, -2),
                      blurRadius: 6.0,
                    ),
                  ],
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextField(
                    controller: commentController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: const BorderSide(color: Colors.grey),
                      ),
                      contentPadding: const EdgeInsets.all(10.0),
                      prefixIcon: Container(
                        margin: const EdgeInsets.all(4.0),
                        width: 48.0,
                        height: 48.0,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black45,
                              offset: Offset(0, 2),
                              blurRadius: 6.0,
                            ),
                          ],
                        ),
                        child: Container(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          decoration: const BoxDecoration(shape: BoxShape.circle),
                          child: Provider.of<ProfileData>(context, listen: false).photoUrl != ''
                              ? cachedNetworkImage(
                                  Provider.of<ProfileData>(context, listen: false).photoUrl,
                                )
                              : Image.asset('assets/images/profile.jpeg'),
                        ),
                      ),
                      suffixIcon: Container(
                        width: 60.0,
                        child: FloatingActionButton(
                          backgroundColor: kPrimaryColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(70.0),
                          ),
                          onPressed: () => {
                            //Iniciamos el chat
                            ChatController.saveChat(userId, followedID.toString(),commentController,Provider.of<ProfileData>(context, listen: false).photoUrl, context),
                            Navigator.pop(context)
                          },
                          child: const Icon(
                            Icons.send,
                            size: 25.0,
                            color: UiColors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // body: ,
          );
        });
  }
}
