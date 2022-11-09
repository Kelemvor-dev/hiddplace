import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/repository/publications.dart';

class PublicationController{

  static void likePublication(String? publicationID, List? likes, String? userID, BuildContext context) async {
    context.read<Publications>().likePublication(publicationID: publicationID, likes: likes, userID: userID);
  }

  static void unlikePublication(String? publicationID, List? likes, String? userID, BuildContext context) async {
    context.read<Publications>().unlikePublication(publicationID: publicationID, likes: likes, userID: userID);
  }

  static void deletePublication(id,userId, BuildContext context) {
    context.read<Publications>().deletePublication(context, userId, id);
  }

  static void savePublication(BuildContext context,titleController,contentController,imageFileList) async {
    context.read<Publications>().savePublication(
      title: titleController.text,
      content: contentController.text,
      listImages: imageFileList,
      context: context,
    );
  }

}