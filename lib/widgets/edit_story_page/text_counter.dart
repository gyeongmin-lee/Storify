import 'package:flutter/material.dart';
import 'package:storify/constants/style.dart';

class TextCounter extends StatelessWidget {
  const TextCounter(
      {Key key, @required this.textLength, @required this.maxLength})
      : super(key: key);
  final int textLength;
  final int maxLength;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: Colors.green,
            border: Border.all(
              color: Colors.transparent,
            ),
            borderRadius: BorderRadius.all(Radius.circular(30.0))),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 1.0),
          child: Text(
            '$textLength/$maxLength',
            style:
                TextStyles.primary.copyWith(letterSpacing: 0.3, fontSize: 12.0),
          ),
        ));
  }
}
