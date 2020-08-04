import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:storify/constants/style.dart';

class PlayListItem extends StatelessWidget {
  const PlayListItem(
      {Key key,
      @required this.imageUrl,
      @required this.title,
      @required this.subtitle,
      this.onPressed})
      : super(key: key);

  final String imageUrl;
  final String title;
  final String subtitle;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      leading: CircleAvatar(
        radius: 25,
        backgroundImage:
            imageUrl != null ? CachedNetworkImageProvider(imageUrl) : null,
        backgroundColor: Colors.transparent,
      ),
      title: Text(title,
          style: TextStyles.primary.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
          )),
      subtitle: Text(subtitle,
          style: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w300,
            color: Colors.white30,
          )),
      onTap: onPressed,
    );
  }
}
