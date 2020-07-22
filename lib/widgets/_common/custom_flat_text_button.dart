import 'package:flutter/material.dart';
import 'package:storify/constants/style.dart';

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
          style: TextStyles.buttonText.copyWith(
            fontSize: 22.0,
          )),
      onPressed: onPressed,
    );
  }
}
