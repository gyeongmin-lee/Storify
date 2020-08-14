import 'package:flutter/material.dart';
import 'package:storify/constants/style.dart';

class BaseScaffold extends StatelessWidget {
  final String titleText;
  final Widget bottomNavigationBar;
  final Widget body;
  final bool hideAppBar;

  const BaseScaffold(
      {Key key,
      @required this.titleText,
      @required this.bottomNavigationBar,
      @required this.body,
      this.hideAppBar = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: false,
      appBar: !hideAppBar
          ? AppBar(
              title: Text(
                titleText,
                style: TextStyles.appBarTitle,
              ),
              centerTitle: true,
              elevation: 0,
              backgroundColor: Colors.transparent,
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(1.0),
                child: Divider(
                  color: Colors.white10,
                  thickness: 1.0,
                  height: 1.0,
                ),
              ),
            )
          : null,
      bottomNavigationBar: bottomNavigationBar,
      body: body,
    );
  }
}
