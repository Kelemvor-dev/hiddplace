import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import '../models/services/publications.dart';

class CommentController{
  static void saveComment(String? publicationID, BuildContext context,commentController) async {
    context.read<Publications>().saveComment(
      comment: commentController.text,
      publicationID: publicationID,
      context: context,
    );
  }

  static void likeComment(String? commentID, List? likes, String? userID, BuildContext context) async {
    context.read<Publications>().likeComment(commentID: commentID, likes: likes, userID: userID);
  }

  static void unlikeComment(String? commentID, List? likes, String? userID, BuildContext context) async {
    context.read<Publications>().unlikeComment(commentID: commentID, likes: likes, userID: userID);
  }
}