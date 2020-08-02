import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:storify/widgets/_common/status_indicator.dart';

class OverlayLoader {
  static void show({@required String loadingText}) {
    BotToast.showCustomLoading(
      crossPage: false,
      backgroundColor: Colors.black38,
      toastBuilder: (cancelFunc) => Container(
        height: 150,
        width: 150,
        decoration: BoxDecoration(
            color: Colors.black87,
            border: Border.all(
              color: Colors.transparent,
            ),
            borderRadius: BorderRadius.all(Radius.circular(12))),
        child: Center(
          child: StatusIndicator(
            message: loadingText,
            status: Status.loading,
          ),
        ),
      ),
    );
  }
}
