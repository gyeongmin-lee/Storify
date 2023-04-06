import 'package:flutter/material.dart';
import 'package:storify/constants/style.dart';

class CustomFlatTextButton extends StatelessWidget {
  const CustomFlatTextButton({
    Key key,
    this.onPressed,
    this.text,
    this.leadingWidget,
  }) : super(key: key);
  final VoidCallback onPressed;
  final String text;
  final Widget leadingWidget;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: EdgeInsets.symmetric(vertical: 12.0),
      ),
      child:
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
        if (leadingWidget != null) ...[
          leadingWidget,
          SizedBox(
            width: 12.0,
          ),
        ],
        Text(text,
            style: TextStyles.buttonText.copyWith(
              fontSize: 22.0,
            )),
      ]),
      onPressed: onPressed,
    );
  }
}
