import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hiddplace/src/controllers/chatController.dart';
import 'package:hiddplace/src/models/repository/chat.dart';
import 'package:hiddplace/src/models/repository/users.dart';
import 'package:provider/provider.dart';

import '../../../../constants.dart';
import '../../../../utils/cachedNetworkImage.dart';
import '../../../models/providers/profile.dart';
import '../../components/navbar/popNavbar.dart';
import 'package:intl/intl.dart';

import '../../widgets/profileModal.dart';

class ChatTalkScreen extends StatefulWidget {
  const ChatTalkScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<ChatTalkScreen> createState() => _ChatTalkScreenState();
}

class _ChatTalkScreenState extends State<ChatTalkScreen> {
  final TextEditingController commentController = TextEditingController();
  final userId = FirebaseAuth.instance.currentUser?.uid;
  late var chat;

  _buildProfile(String? userId) {
    showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return ProfileModal(
            userId: userId,
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    Map args = ModalRoute.of(context)?.settings.arguments as Map;
    return StreamBuilder(
        stream: UserProfile().getUserByID(args['followedID']),
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
                              //Cuntinuamos el chat
                              ChatController.saveTalkChat(
                                  args['chatID'],
                                  commentController,
                                  Provider.of<ProfileData>(context, listen: false).photoUrl,
                                  Provider.of<ProfileData>(context, listen: false).uid,
                                  chat,
                                  context),
                              commentController.text = ''
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
              body: StreamBuilder(
                  stream: Chat().getChatByID(args['chatID']),
                  builder: (context, snapshot) {
                    return (snapshot.data?.docs != null)
                        ? ListView.builder(
                            padding: const EdgeInsets.all(5.5),
                            itemCount: snapshot.data?.docs.length,
                            itemBuilder: (context, index) {
                              chat = snapshot.data?.docs[index].data()['chat'];
                              return Column(
                                children: <Widget>[
                                  SizedBox(
                                      child: Column(children: [
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: SingleChildScrollView(
                                          child: Column(children: [
                                        ListView.builder(
                                            shrinkWrap: true,
                                            physics: const NeverScrollableScrollPhysics(),
                                            padding: const EdgeInsets.all(5.5),
                                            itemCount: snapshot.data?.docs[index].data()['chat'].length,
                                            itemBuilder: (context, indexChat) {
                                              DateTime date = (snapshot.data?.docs[index].data()['chat'][indexChat]['timestamp']).toDate();
                                              return Container(
                                                margin: const EdgeInsets.only(top: 10),
                                                padding: const EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(10),
                                                  color: kPrimaryColor,
                                                ),
                                                child: ListTile(
                                                  leading: InkWell(
                                                      onTap: () {
                                                        _buildProfile(snapshot.data?.docs[index].data()['chat'][indexChat]['userID']);
                                                      },
                                                      child: Container(
                                                        width: 50.0,
                                                        height: 50.0,
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
                                                          child: snapshot.data?.docs[index].data()['chat'][indexChat]['imageUrl'] != null
                                                              ? cachedNetworkImage(snapshot.data?.docs[index].data()['chat'][indexChat]['imageUrl'])
                                                              : Image.asset('assets/images/profile.jpeg'),
                                                        ),
                                                      )),
                                                  title: Text(
                                                    '${snapshot.data?.docs[index].data()['chat'][indexChat]['comment']}',
                                                    style: const TextStyle(
                                                      color: UiColors.white,
                                                    ),
                                                  ),
                                                  subtitle: Text(
                                                    DateFormat.yMMMd().add_jm().format(date),
                                                    style: const TextStyle(color: UiColors.white, fontSize: 11),
                                                  ),
                                                ),
                                              );
                                            })
                                      ])),
                                    ),
                                  ]))
                                ],
                              );
                            })
                        : const Center(child: CircularProgressIndicator());
                  }));
        });
  }
}
