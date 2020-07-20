import 'dart:ui';

import 'package:flutter/material.dart';

final kPrimaryTextStyle = TextStyle(color: Colors.white.withOpacity(0.75));

final kSecondaryTextStyle = TextStyle(color: Colors.white54);

final kButtonTextStyle =
    kPrimaryTextStyle.copyWith(fontWeight: FontWeight.w300, letterSpacing: 4.0);

final kLightTextStyle =
    kSecondaryTextStyle.copyWith(fontWeight: FontWeight.w300);

final kBannerTextStyle = kPrimaryTextStyle.copyWith(
    fontSize: 36.0, fontWeight: FontWeight.bold, letterSpacing: 5.0);

final kAppBarTitleTextStyle =
    kSecondaryTextStyle.copyWith(fontSize: 20.0, letterSpacing: 2.0);

final kAvatarTitleTextStyle = kPrimaryTextStyle.copyWith(
  fontWeight: FontWeight.bold,
  fontSize: 22.0,
);

final kSmallButtonTextStyle = kSecondaryTextStyle.copyWith(
  fontSize: 12.0,
  fontWeight: FontWeight.bold,
  letterSpacing: 1.5,
);
