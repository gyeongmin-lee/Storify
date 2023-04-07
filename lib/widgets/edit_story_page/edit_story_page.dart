import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:storify/constants/style.dart';
import 'package:storify/models/track.dart';
import 'package:storify/widgets/_common/custom_rounded_button.dart';
import 'package:storify/widgets/_common/overlay_loader.dart';
import 'package:storify/constants/values.dart' as Constants;
import 'package:storify/widgets/edit_story_page/text_counter.dart';

class EditStoryPage extends StatefulWidget {
  const EditStoryPage(
      {Key? key,
      required this.track,
      required this.originalStoryText,
      required this.onStoryTextEdited})
      : super(key: key);
  final Track track;
  final String originalStoryText;
  final Function(String) onStoryTextEdited;

  static void show(
    BuildContext context, {
    required Track track,
    required String originalStoryText,
    required Function(String) onStoryTextEdited,
  }) {
    Navigator.of(context).push(PageRouteBuilder(
      opaque: false,
      pageBuilder: (BuildContext context, _, __) => EditStoryPage(
        track: track,
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

  @override
  _EditStoryPageState createState() => _EditStoryPageState();
}

class _EditStoryPageState extends State<EditStoryPage> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.originalStoryText);
  }

  Future<void> _onSubmitted(BuildContext context) async {
    OverlayLoader.show(loadingText: 'UPDATING');
    await widget.onStoryTextEdited(_controller.text);
    Navigator.of(context).pop();
  }

  bool get _shouldDisplayCounter =>
      _controller.text.length > Constants.displayCounterWhenLength;

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
            extendBodyBehindAppBar: false,
            backgroundColor: Colors.transparent,
            appBar: _buildAppBar(context),
            body: Container(
              height: double.infinity,
              width: double.infinity,
              child: Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: TextField(
                    keyboardType: TextInputType.multiline,
                    maxLength: Constants.storyTextMaxLength,
                    maxLines: null,
                    autofocus: true,
                    controller: _controller,
                    style: TextStyles.secondary.copyWith(fontSize: 18.0),
                    onChanged: (_) => setState(() {}),
                    decoration: InputDecoration(
                        hintText: 'Add your description for this track',
                        border: InputBorder.none,
                        counter: _shouldDisplayCounter
                            ? TextCounter(
                                textLength: _controller.text.length,
                                maxLength: Constants.storyTextMaxLength,
                              )
                            : null,
                        counterText: '',
                        contentPadding: EdgeInsets.only(
                            bottom: 4.0, left: 16.0, right: 16.0, top: 16.0),
                        focusedBorder: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        hintStyle: TextStyle(
                            color: Colors.white12,
                            fontWeight: FontWeight.w300)),
                  )),
            ),
          ),
        )
      ],
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        widget.track.name!,
        style: TextStyles.primary.copyWith(fontSize: 20.0),
      ),
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.black26,
      leading: OverflowBox(
        maxWidth: 120,
        child: Padding(
          padding: const EdgeInsets.only(left: 24.0),
          child: TextButton(
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
