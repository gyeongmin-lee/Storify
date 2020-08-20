import 'package:flutter/material.dart';
import 'package:storify/constants/style.dart';

class PlayerPlayButton extends StatelessWidget {
  final bool isPlaying;

  const PlayerPlayButton({Key key, @required this.isPlaying}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Icon(
        isPlaying ? Icons.pause : Icons.play_arrow,
        size: 40.0,
        color: CustomColors.primaryTextColor,
      ),
      decoration: BoxDecoration(shape: BoxShape.circle),
    );
  }
}
