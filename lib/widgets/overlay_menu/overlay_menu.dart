import 'package:flutter/material.dart';
import 'package:storify/constants/style.dart';
import 'package:storify/widgets/_common/custom_flat_icon_button.dart';

class OverlayMenu extends StatelessWidget {
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
