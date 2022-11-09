import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hiddplace/constants.dart';
import 'package:hiddplace/src/controllers/commentController.dart';
import 'package:provider/provider.dart';
import '../../views/components/navbar/popNavbar.dart';
import '../../models/providers/profile.dart';
import '../../models/repository/publications.dart';

class Comments extends StatefulWidget {
  final String? publicationID;

  const Comments({Key? key, required this.publicationID}) : super(key: key);

  @override
  State<Comments> createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  final TextEditingController commentController = TextEditingController();
  final FirebaseFirestore db = FirebaseFirestore.instance;
  final userId = FirebaseAuth.instance.currentUser?.uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const PopNavbar(title: "Comentarios", transparent: false, bgColor: kPrimaryColor),
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
                  hintText: '  Add a comment',
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
                          ? Image.network(
                              Provider.of<ProfileData>(context, listen: false).photoUrl,
                              fit: BoxFit.cover,
                            )
                          : Image.asset('assets/images/profile.jpeg'),
                    ),
                  ),
                  suffixIcon: Container(
                    margin: const EdgeInsets.only(right: 4.0),
                    width: 70.0,
                    child: FloatingActionButton(
                      backgroundColor: kPrimaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50.0),
                      ),
                      onPressed: () => { CommentController.saveComment(widget.publicationID,context,commentController), commentController.text = ''},
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
            stream: Publications().getComments(widget.publicationID),
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
                                          ? Image.network(
                                              snapshot.data?.docs[index].data()['user']['imageUrl'],
                                              fit: BoxFit.cover,
                                            )
                                          : Image.asset('assets/images/profile.jpeg'),
                                    ),
                                  ),
                                  title: Text(
                                    '${snapshot.data?.docs[index].data()['user']['name']} ${snapshot.data?.docs[index].data()['user']['lastname']}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  subtitle: Text('${snapshot.data?.docs[index].data()['comment']}'),
                                  trailing: (snapshot.data?.docs[index].data()['likes']!.contains(userId))
                                      ? Row(mainAxisSize: MainAxisSize.min, children: [
                                          Text(
                                            (snapshot.data?.docs[index].data()['likes'] != null)
                                                ? '${snapshot.data?.docs[index].data()['likes']?.length}'
                                                : '0',
                                            style: const TextStyle(
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          IconButton(
                                            icon: const Icon(
                                              FontAwesomeIcons.solidThumbsUp,
                                              color: UiColors.like,
                                            ),
                                            iconSize: 30.0,
                                            onPressed: () => CommentController.unlikeComment(
                                                snapshot.data?.docs[index].data()['id'], snapshot.data?.docs[index].data()['likes'], userId,context),
                                          )
                                        ])
                                      : Row(mainAxisSize: MainAxisSize.min, children: [
                                          Text(
                                            (snapshot.data?.docs[index].data()['likes'] != null)
                                                ? '${snapshot.data?.docs[index].data()['likes']?.length}'
                                                : '0',
                                            style: const TextStyle(
                                              fontSize: 14.0,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          IconButton(
                                            icon: const Icon(FontAwesomeIcons.thumbsUp),
                                            iconSize: 30.0,
                                            onPressed: () => CommentController.likeComment(
                                                snapshot.data?.docs[index].data()['id'], snapshot.data?.docs[index].data()['likes'], userId,context),
                                          )
                                        ]),
                                ),
                              ),
                            ]))
                          ],
                        );
                      })
                  : const Center(child: CircularProgressIndicator());
            }));
  }
}
