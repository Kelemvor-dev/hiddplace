import 'package:flutter/cupertino.dart';
import 'package:hiddplace/src/models/repository/follower.dart';
import 'package:provider/provider.dart';


class FollowerController{

  static void follow(userID, followedID,user, BuildContext context) async {
    context.read<Follower>().follow(userID: userID, followedID: followedID, user: user);
  }

  static void unfollow(followID, BuildContext context) async {
    context.read<Follower>().unfollow(followID: followID);
  }
}