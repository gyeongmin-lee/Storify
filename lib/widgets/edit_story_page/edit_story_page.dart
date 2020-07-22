import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:storify/constants/style.dart';
import 'package:storify/models/song.dart';
import 'package:storify/widgets/_common/custom_rounded_button.dart';

class EditStoryPage extends StatelessWidget {
  const EditStoryPage(
      {Key key,
      @required this.song,
      @required this.originalStoryText,
      @required this.onStoryTextEdited})
      : super(key: key);
  final Song song;
  final String originalStoryText;
  final Function(String) onStoryTextEdited;

  static void show(
    BuildContext context, {
    @required Song song,
    @required String originalStoryText,
    @required Function(String) onStoryTextEdited,
  }) {
    Navigator.of(context).push(PageRouteBuilder(
      opaque: false,
      pageBuilder: (BuildContext context, _, __) => EditStoryPage(
        song: song,
        originalStoryText: originalStoryText,
        onStoryTextEdited: onStoryTextEdited,
      ),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(
            CurvedAnimation(
              parent: animation,
              curve: Curves.fastLinearToSlowEaseIn,
            ),
          ),
          child: child,
        );
      },
    ));
  }

  Future<void> _onSubmitted(BuildContext context) async {
    onStoryTextEdited("NEW TEXT");
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(color: Colors.black.withOpacity(0.5)),
        ),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 65.0, sigmaY: 65.0),
          child: Scaffold(
            extendBodyBehindAppBar: true,
            backgroundColor: Colors.transparent,
            appBar: _buildAppBar(context),
            body: Container(
              height: double.infinity,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.only(
                    top: kToolbarHeight + 24.0,
                    right: 16.0,
                    bottom: 16.0,
                    left: 16.0),
                child: TextField(
                  keyboardType: TextInputType.multiline,
                  maxLength: null,
                  maxLines: null,
                  style: TextStyles.secondary.copyWith(fontSize: 18.0),
                  decoration: InputDecoration(
                      hintText: 'Add your description for this track',
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      hintStyle: TextStyle(
                          color: Colors.white12, fontWeight: FontWeight.w300)),
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        song.name,
        style: TextStyles.primary.copyWith(fontSize: 20.0),
      ),
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.black26,
      leading: OverflowBox(
        maxWidth: 120,
        child: Padding(
          padding: const EdgeInsets.only(left: 24.0),
          child: FlatButton(
              child: Text(
                'CANCEL',
                style: TextStyles.smallButtonText,
              ),
              onPressed: () => Navigator.of(context).pop()),
        ),
      ),
      actions: <Widget>[
        Center(
          child: Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: CustomRoundedButton(
                size: ButtonSize.small,
                backgroundColor: Colors.green,
                borderColor: Colors.green,
                textColor: CustomColors.primaryTextColor,
                buttonText: 'SAVE',
                onPressed: () => _onSubmitted(context)),
          ),
        ),
      ],
    );
  }
}
