import 'package:flutter/material.dart';
import 'package:storify/constants/style.dart';
import 'package:storify/models/playlist.dart';
import 'package:storify/widgets/_common/custom_flat_icon_button.dart';
import 'package:storify/widgets/_common/overlay_menu.dart';
import 'package:storify/widgets/main_menu_body/main_menu_body.dart';
import 'package:storify/widgets/more_info_menu_body/more_info_menu_body.dart';

class PlayerPage extends StatefulWidget {
  static const routeName = '/player';

  @override
  _PlayerState createState() => _PlayerState();
}

class _PlayerState extends State<PlayerPage> {
  Playlist playlist;

  @override
  void initState() {
    super.initState();
    playlist = Playlist(name: 'John\'s playlist');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          playlist.name,
          style: kAppBarTitleTextStyle,
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: CustomFlatIconButton(
            icon: Icon(
              Icons.menu,
              color: kAppBarTitleTextStyle.color,
            ),
            onPressed: () =>
                OverlayMenu.show(context, menuBody: MainMenuBody())),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'MORE',
              style: TextStyle(
                fontSize: 12.0,
                color: Colors.white60,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.5,
              ),
            ),
            onPressed: () =>
                OverlayMenu.show(context, menuBody: MoreInfoMenuBody()),
          ),
        ],
      ),
      body: _buildContent(),
    );
  }

  Widget _buildContent() {
    return Container(
      child: Center(
        child: Text(
          "HELLO",
          style: kBannerTextStyle,
        ),
      ),
    );
  }
}
