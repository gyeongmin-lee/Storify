import 'dart:ui';

import 'package:flutter/material.dart';

class CustomColors {
  static const primaryTextColor = Color.fromRGBO(255, 255, 255, 0.75);
  static const secondaryTextColor = Colors.white54;
}

class TextStyles {
  static final primary = TextStyle(color: CustomColors.primaryTextColor);

  static final secondary = TextStyle(color: CustomColors.secondaryTextColor);

  static final buttonText =
      primary.copyWith(fontWeight: FontWeight.w300, letterSpacing: 4.0);

  static final light = secondary.copyWith(fontWeight: FontWeight.w300);

  static final bannerText = primary.copyWith(
      fontSize: 36.0, fontWeight: FontWeight.bold, letterSpacing: 5.0);

  static final appBarTitle = primary.copyWith(
      fontSize: 20.0, letterSpacing: 2.0, fontWeight: FontWeight.bold);

  static final smallButtonText = secondary.copyWith(
    fontSize: 12.0,
    fontWeight: FontWeight.bold,
    letterSpacing: 1.5,
  );

  static final loadingButtonText = secondary.copyWith(
      fontSize: 14.0, letterSpacing: 2.0, fontWeight: FontWeight.w300);
}

class DisableGlowScrollBehaviour extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
