import 'package:flutter/material.dart';

class CustomFlatIconButton extends StatelessWidget {
  const CustomFlatIconButton(
      {Key? key, required this.icon, required this.onPressed})
      : super(key: key);
  final Icon icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        icon: icon,
        onPressed: onPressed);
  }
}
