import 'package:flutter/material.dart';
import 'package:storify/constants/style.dart';

class PlayerPlayButton extends StatelessWidget {
  final bool isPlaying;

  const PlayerPlayButton({Key key, @required this.isPlaying}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(9.0),
      child: Icon(
        isPlaying ? Icons.pause : Icons.play_arrow,
        size: 36.0,
        color: CustomColors.primaryTextColor,
      ),
      decoration: BoxDecoration(color: Colors.black26, shape: BoxShape.circle),
    );
  }
}
