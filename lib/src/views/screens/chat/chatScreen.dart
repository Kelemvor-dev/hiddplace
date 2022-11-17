import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hiddplace/src/controllers/chatController.dart';
import 'package:hiddplace/src/models/repository/chat.dart';

import '../../../../constants.dart';
import '../../../../utils/cachedNetworkImage.dart';
import '../../widgets/usersFollowModal.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final userId = FirebaseAuth.instance.currentUser?.uid;

  _buildUsersModal() {
    showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return const UsersFollowModal();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: kPrimaryColor,
        onPressed: () {
          _buildUsersModal();
        },
        child: const FaIcon(
          color: UiColors.white,
          FontAwesomeIcons.solidMessage,
          size: 25,
        ),
      ),
      body: StreamBuilder(
          stream: Chat().getChatByUserID(userId),
          builder: (context, snapshot) {
            return (snapshot.data?.docs != null)
                ? ListView.builder(
                    padding: const EdgeInsets.all(5.5),
                    itemCount: snapshot.data?.docs.length,
                    itemBuilder: (context, index) {
                      final followedID = snapshot.data?.docs[index].data()['users'];
                      return Column(
                        children: <Widget>[
                          SizedBox(
                              child: Column(children: [
                            Padding(
                              padding: const EdgeInsets.all(1.0),
                              child: InkWell(
                                  onTap: () {
                                    Navigator.pushNamed(context, 'chatTalk', arguments: {
                                      'followedID': followedID[0] != userId ? followedID[0] : followedID[1],
                                      'chatID': snapshot.data?.docs[index].data()['id']
                                    });
                                  },
                                  child: ListTile(
                                    leading: Container(
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
                                      child: StreamBuilder(
                                          stream: Chat().getUserChatByID(followedID[0] != userId ? followedID[0] : followedID[1]),
                                          builder: (context, userProfile) {
                                            return Container(
                                              clipBehavior: Clip.antiAliasWithSaveLayer,
                                              decoration: const BoxDecoration(shape: BoxShape.circle),
                                              child: userProfile.data?.docs.first.data()['photoUrl'] != null
                                                  ? cachedNetworkImage(userProfile.data?.docs.first.data()['photoUrl'])
                                                  : Image.asset('assets/images/profile.jpeg'),
                                            );
                                          }),
                                    ),
                                    title: StreamBuilder(
                                        stream: Chat().getUserChatByID(followedID[0] != userId ? followedID[0] : followedID[1]),
                                        builder: (context, userNames) {
                                          return Text(
                                            '${userNames.data?.docs.first.data()['name']} ${userNames.data?.docs.first.data()['lastname']}',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          );
                                        }),
                                    subtitle: Text('${snapshot.data?.docs[index].data()['chat'].last['comment']}',overflow: TextOverflow.ellipsis,),
                                      trailing: IconButton(
                                        icon: const Icon(
                                          FontAwesomeIcons.trashCan,
                                          color: UiColors.error,
                                          size: 20,
                                        ),
                                        color: Colors.black,
                                        onPressed: () => ChatController.deleteChat(
                                            snapshot.data?.docs[index].data()['id'], context),
                                      )
                                  )),
                            ),
                          ]))
                        ],
                      );
                    })
                : const Center(child: CircularProgressIndicator());
          }),
    );
  }
}
