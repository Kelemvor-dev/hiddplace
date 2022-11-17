import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:hiddplace/src/models/repository/chat.dart';
import 'package:provider/provider.dart';

import '../models/entity/chat.dart';

class ChatController {
  final userId = FirebaseAuth.instance.currentUser?.uid;

  static void saveChat(String? userID, String? followedID, commentController, imageUrl, BuildContext context) async {
    context.read<Chat>().saveChat(
          userID: userID,
          followedID: followedID,
          context: context,
          comment: commentController.text,
          imageUrl: imageUrl,
        );
  }

  static void saveTalkChat(String? id, commentController, imageUrl,userID, chat, BuildContext context) async {
    context.read<Chat>().saveTalkChat(
          id: id,
          context: context,
          userID: userID,
          comment: commentController.text,
          imageUrl: imageUrl,
          chat: chat,
        );
  }

  static void deleteChat(String? id, BuildContext context) async {
    context.read<Chat>().deleteChat(
          id: id,
          context: context,
        );
  }

  newChatScreen(userID, context) async {
    var list = Chat().getUsersChat(userId);
    var state = await list.then((res) {
      List data = res.docs.map((document) => document.data()).toList();
      for (var doc in data) {
        for (var user in doc['users']) {
          if (user == userID) {
            return doc['id'];
          }
        }
      }
    });
    return state;
  }
}
