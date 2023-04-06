import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:storify/constants/style.dart';

enum ToastType { error, warning, info, success }

class CustomToast {
  static Map<ToastType, Widget> toastIcon = {
    ToastType.error: Icon(
      Icons.error,
      color: Colors.red,
    ),
    ToastType.warning: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.0),
        child: Icon(Icons.warning, color: Colors.orange, size: 16.0)),
    ToastType.info: Icon(Icons.info, color: CustomColors.primaryTextColor),
    ToastType.success: Icon(Icons.check_circle, color: Colors.green),
  };

  static void showTextToast(
      {required String text, required ToastType toastType}) {
    BotToast.showCustomText(
      toastBuilder: (_) => Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        elevation: 0,
        color: Colors.grey[850],
        child: Padding(
          padding: const EdgeInsets.only(
              left: 4.0, right: 8.0, top: 4.0, bottom: 4.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              toastIcon[toastType]!,
              SizedBox(
                width: 4.0,
              ),
              Text(
                text,
                style: TextStyles.primary.copyWith(
                    fontSize: 14.0,
                    letterSpacing: 0.6,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
