import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:storify/constants/style.dart';
import 'package:storify/constants/values.dart' as Constants;
import 'package:storify/widgets/_common/custom_rounded_button.dart';

class OverlayModal {
  static void show({VoidCallback onConfirm, VoidCallback onCancel}) {
    BotToast.showAnimationWidget(
        clickClose: false,
        allowClick: false,
        onlyOne: true,
        crossPage: true,
        backButtonBehavior: BackButtonBehavior.close,
        wrapToastAnimation: (controller, cancel, child) => Stack(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                    cancel();
                  },
                  child: AnimatedBuilder(
                    builder: (_, child) => Opacity(
                      opacity: controller.value,
                      child: child,
                    ),
                    child: DecoratedBox(
                      decoration: BoxDecoration(color: Colors.black38),
                      child: SizedBox.expand(),
                    ),
                    animation: controller,
                  ),
                ),
                CustomOffsetAnimation(
                  controller: controller,
                  child: child,
                )
              ],
            ),
        toastBuilder: (cancelFunc) => AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            insetPadding: EdgeInsets.all(24.0),
            contentPadding: EdgeInsets.only(
                top: 16.0, right: 16.0, bottom: 24.0, left: 16.0),
            backgroundColor: Colors.black87,
            content: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  Icons.info,
                  color: CustomColors.primaryTextColor,
                  size: 72.0,
                ),
                SizedBox(height: 12.0),
                Text(
                    'In order to use the playback feature, an active Spotify player is needed'
                    '\n\nOpen Spotify app and play the playlist to enable playback',
                    style: TextStyles.primary.copyWith(
                        height: 1.3,
                        fontWeight: FontWeight.w300,
                        fontSize: 18.0)),
                SizedBox(height: 16.0),
                CustomRoundedButton(
                  borderColor: Colors.green,
                  backgroundColor: Colors.green,
                  textColor: Colors.white,
                  regularLetterSpacing: 0.8,
                  onPressed: () {
                    cancelFunc();
                    onConfirm?.call();
                  },
                  buttonText: 'Open Spotify',
                ),
              ],
            )),
        animationDuration: Constants.dialogAnimationDuration);
  }
}

class CustomOffsetAnimation extends StatefulWidget {
  final AnimationController controller;
  final Widget child;

  const CustomOffsetAnimation({Key key, this.controller, this.child})
      : super(key: key);

  @override
  _CustomOffsetAnimationState createState() => _CustomOffsetAnimationState();
}

class _CustomOffsetAnimationState extends State<CustomOffsetAnimation> {
  Tween<Offset> tweenOffset;
  Tween<double> tweenScale;

  Animation<double> animation;

  @override
  void initState() {
    tweenOffset = Tween<Offset>(
      begin: Offset.zero,
      end: Offset.zero,
    );
    tweenScale = Tween<double>(begin: 1.0, end: 1.0);
    animation =
        CurvedAnimation(parent: widget.controller, curve: Curves.decelerate);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      child: widget.child,
      animation: widget.controller,
      builder: (BuildContext context, Widget child) {
        return FractionalTranslation(
            translation: tweenOffset.evaluate(animation),
            child: ClipRect(
              child: Transform.scale(
                scale: tweenScale.evaluate(animation),
                child: Opacity(
                  child: child,
                  opacity: animation.value,
                ),
              ),
            ));
      },
    );
  }
}
