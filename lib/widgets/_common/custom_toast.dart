import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:storify/constants/style.dart';

enum ToastType { error, info, success }

class CustomToast {
  static Map<ToastType, Widget> toastIcon = {
    ToastType.error:
        Icon(Icons.error_outline_sharp, color: Colors.red, size: 32.0),
    ToastType.info: Icon(Icons.info_outline,
        color: CustomColors.primaryTextColor, size: 32.0),
    ToastType.success:
        Icon(Icons.check_circle_outline_sharp, color: Colors.green, size: 32.0),
  };

  static void showTextToast(
      {required String text, required ToastType toastType}) {
    BotToast.showCustomText(
      toastBuilder: (_) => Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        elevation: 0,
        color: Colors.grey.shade900,
        child: Padding(
          padding: const EdgeInsets.only(
              left: 8.0, right: 16.0, top: 8.0, bottom: 8.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              toastIcon[toastType]!,
              SizedBox(
                width: 12.0,
              ),
              Text(
                text,
                style: TextStyles.primary
                    .copyWith(fontSize: 14.0, fontWeight: FontWeight.w300),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
