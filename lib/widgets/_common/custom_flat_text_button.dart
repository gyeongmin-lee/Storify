import 'package:flutter/material.dart';

class CustomFlatTextButton extends StatelessWidget {
  const CustomFlatTextButton(
      {Key key, @required this.onPressed, @required this.text})
      : super(key: key);
  final VoidCallback onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Text(text,
          style: TextStyle(
              color: Colors.white70,
              fontSize: 22.0,
              fontWeight: FontWeight.w300,
              letterSpacing: 4.0)),
      onPressed: onPressed,
    );
  }
}
