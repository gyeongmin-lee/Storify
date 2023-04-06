import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:storify/constants/style.dart';

class CustomPageViewModel {
  static PageViewModel create(
      {required String titleText,
      required String bodyText,
      required String imagePath}) {
    return PageViewModel(
      image: Padding(
        padding: EdgeInsets.only(top: 128),
        child: SvgPicture.asset(
          imagePath,
        ),
      ),
      title: titleText,
      body: bodyText,
      decoration: PageDecoration(
          titlePadding: EdgeInsets.only(top: 64.0, bottom: 12.0),
          titleTextStyle: TextStyles.primary
              .copyWith(fontSize: 24.0, fontWeight: FontWeight.bold),
          bodyTextStyle: TextStyles.secondary.copyWith(fontSize: 18.0)),
    );
  }
}
