import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hiddplace/src/controllers/chatController.dart';

import '../../../constants.dart';
import '../../../utils/cachedNetworkImage.dart';
import '../../models/repository/follower.dart';
import '../components/navbar/popNavbar.dart';

class UsersFollowModal extends StatefulWidget {
  const UsersFollowModal({
    Key? key,
  }) : super(key: key);

  @override
  State<UsersFollowModal> createState() => _UsersFollowModalState();
}

class _UsersFollowModalState extends State<UsersFollowModal> {
  final userId = FirebaseAuth.instance.currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const PopNavbar(title: "Personas a las que sigo", transparent: false, bgColor: kPrimaryColor),
        body: StreamBuilder(
            stream: Follower().getFollowersByID(userId),
            builder: (context, snapshot) {
              return (snapshot.data?.docs != null)
                  ? ListView.builder(
                      padding: const EdgeInsets.all(5.5),
                      itemCount: snapshot.data?.docs.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: <Widget>[
                            SizedBox(
                                child: Column(children: [
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: InkWell(
                                    onTap: () async {
                                      Navigator.pop(context);
                                      var state = await ChatController().newChatScreen(snapshot.data?.docs[index].data()['followedID'], context);
                                      if(state != null){
                                        Navigator.pushNamed(context, 'chatTalk', arguments: {
                                          'followedID': snapshot.data?.docs[index].data()['followedID'],
                                          'chatID': state
                                        });
                                      }else{
                                        Navigator.pushNamed(context, 'newTalk', arguments: snapshot.data?.docs[index].data()['followedID']);
                                      }
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
                                        child: Container(
                                          clipBehavior: Clip.antiAliasWithSaveLayer,
                                          decoration: const BoxDecoration(shape: BoxShape.circle),
                                          child: snapshot.data?.docs[index].data()['user']['imageUrl'] != ''
                                              ? cachedNetworkImage(snapshot.data?.docs[index].data()['user']['imageUrl'])
                                              : Image.asset('assets/images/profile.jpeg'),
                                        ),
                                      ),
                                      title: Text(
                                        '${snapshot.data?.docs[index].data()['user']['name']} ${snapshot.data?.docs[index].data()['user']['lastname']}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    )),
                              ),
                            ]))
                          ],
                        );
                      })
                  : const Center(child: CircularProgressIndicator());
            }));
  }
}
