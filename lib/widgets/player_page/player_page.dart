import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:storify/constants/style.dart';
import 'package:storify/models/artist.dart';
import 'package:storify/models/playlist.dart';
import 'package:storify/models/song.dart';
import 'package:storify/widgets/_common/custom_flat_icon_button.dart';
import 'package:storify/widgets/_common/custom_rounded_button.dart';
import 'package:storify/widgets/_common/overlay_menu.dart';
import 'package:storify/widgets/main_menu_body/main_menu_body.dart';
import 'package:storify/widgets/more_info_menu_body/more_info_menu_body.dart';
import 'package:storify/widgets/player_page/player_progress_bar.dart';

class PlayerPage extends StatefulWidget {
  static const routeName = '/player';

  @override
  _PlayerState createState() => _PlayerState();
}

class _PlayerState extends State<PlayerPage> {
  Playlist playlist = Playlist(name: 'John\'s playlist');
  Song song = Song(
      name: 'Hmmm',
      artist: Artist(
          name: 'Ready',
          artistImageUrl:
              'https://cdn.icon-icons.com/icons2/1736/PNG/512/4043260-avatar-male-man-portrait_113269.png'),
      albumImageUrl:
          'https://image.genie.co.kr/Y/IMAGE/IMG_ALBUM/081/443/375/81443375_1589523123165_1_600x600.JPG');

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.network(
          song.albumImageUrl,
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          fit: BoxFit.cover,
        ),
        Container(
          decoration: BoxDecoration(color: Colors.black.withOpacity(0.7)),
        ),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 35.0, sigmaY: 35.0),
          child: Scaffold(
            extendBodyBehindAppBar: true,
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: Text(
                playlist.name,
                style: kAppBarTitleTextStyle.copyWith(letterSpacing: 0),
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
                    style: kSmallButtonTextStyle,
                  ),
                  onPressed: () =>
                      OverlayMenu.show(context, menuBody: MoreInfoMenuBody()),
                ),
              ],
            ),
            body: _buildContent(),
          ),
        )
      ],
    );
  }

  Widget _buildContent() {
    return Center(
        child: Padding(
      padding: const EdgeInsets.only(top: 128.0, bottom: 36.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            children: <Widget>[
              CircleAvatar(
                  radius: 54.0,
                  backgroundColor: Colors.transparent,
                  backgroundImage: NetworkImage(song.artist.artistImageUrl)),
              SizedBox(
                height: 8.0,
              ),
              Text(song.artist.name,
                  style: kSecondaryTextStyle.copyWith(fontSize: 16.0)),
              Text(song.name,
                  style: kPrimaryTextStyle.copyWith(
                      fontSize: 60.0,
                      fontWeight: FontWeight.w600,
                      height: 1.1,
                      letterSpacing: -1.5)),
              SizedBox(
                height: 16.0,
              ),
              CustomRoundedButton(
                size: ButtonSize.small,
                buttonText: 'ADD A STORY',
                onPressed: () {},
              )
            ],
          ),
          PlayerProgressBar(
            totalValue: 360,
            initialValue: 270,
            onChangeEnd: (double value) {},
          ),
        ],
      ),
    ));
  }
}
