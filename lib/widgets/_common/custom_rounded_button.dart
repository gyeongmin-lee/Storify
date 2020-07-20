import 'package:flutter/material.dart';
import 'package:storify/constants/style.dart';

class CustomRoundedButton extends StatelessWidget {
  const CustomRoundedButton(
      {Key key, @required this.onPressed, @required this.buttonText})
      : super(key: key);
  final VoidCallback onPressed;
  final String buttonText;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: onPressed,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32.0),
          side: BorderSide(color: Colors.white54)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6.0, vertical: 12.0),
        child: Text(
          buttonText,
          style: TextStyle(
              fontSize: 18.0, color: Colors.white54, letterSpacing: 4.0),
        ),
      ),
    );
  }
}
