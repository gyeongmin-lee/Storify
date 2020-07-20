import 'package:flutter/material.dart';
import 'package:storify/constants/style.dart';

enum ButtonSize { regular, small }

class CustomRoundedButton extends StatelessWidget {
  const CustomRoundedButton({
    Key key,
    @required this.onPressed,
    @required this.buttonText,
    this.size = ButtonSize.regular,
    this.borderColor = Colors.white54,
    this.backgroundColor = Colors.transparent,
  }) : super(key: key);
  final VoidCallback onPressed;
  final String buttonText;
  final ButtonSize size;
  final Color borderColor;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      minWidth: 36.0,
      height: 10.0,
      child: FlatButton(
        onPressed: onPressed,
        color: backgroundColor,
        padding: size == ButtonSize.regular
            ? const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0)
            : EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32.0),
            side: BorderSide(
                color: borderColor,
                width: size == ButtonSize.regular ? 2.0 : 1.0)),
        child: Text(
          buttonText,
          style: size == ButtonSize.regular
              ? kSecondaryTextStyle.copyWith(fontSize: 18.0, letterSpacing: 4.0)
              : kSmallButtonTextStyle,
        ),
      ),
    );
  }
}
