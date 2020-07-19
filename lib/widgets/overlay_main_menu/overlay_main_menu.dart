import 'package:flutter/material.dart';
import 'package:storify/constants/style.dart';
import 'package:storify/widgets/_common/custom_flat_icon_button.dart';

class OverlayMainMenu extends StatelessWidget {
  static void show(BuildContext context) {
    Navigator.of(context).push(PageRouteBuilder(
      opaque: false,
      pageBuilder: (BuildContext context, _, __) => OverlayMainMenu(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final tween = Tween(begin: 0.0, end: 1.0);
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.ease,
        );

        return FadeTransition(
          opacity: tween.animate(curvedAnimation),
          child: child,
        );
      },
    ));
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: kLightBlur,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            leading: CustomFlatIconButton(
              icon: Icon(
                Icons.close,
                color: kAppBarTitleTextStyle.color,
              ),
              onPressed: () => Navigator.of(context).pop(),
            )),
        backgroundColor:
            Theme.of(context).scaffoldBackgroundColor.withOpacity(0.75),
        body: Center(
            child: Text(
          "HELLO",
          style: kBannerTextStyle,
        )),
      ),
    );
  }
}
