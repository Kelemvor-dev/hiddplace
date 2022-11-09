import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:hiddplace/constants.dart';

Widget cachedNetworkImage(String mediaUrl) {
  return CachedNetworkImage(
    imageUrl: mediaUrl,
    fit: BoxFit.cover,
    placeholder: (context, url) =>
        const Padding(padding: EdgeInsets.all(20.0), child: Center(child: CircularProgressIndicator(color: kPrimaryColor))),
    errorWidget: (context, url, error) => const Icon(Icons.error),
  );
}
