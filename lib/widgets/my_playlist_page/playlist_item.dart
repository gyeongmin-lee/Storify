import 'package:flutter/material.dart';

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
        backgroundImage: NetworkImage(imageUrl),
      ),
      title: Text(title,
          style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
              color: Colors.white70)),
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
