import 'package:flutter/material.dart';
import 'package:storify/constants/style.dart';
import 'package:storify/models/playlist.dart';
import 'package:storify/models/user.dart';
import 'package:storify/widgets/_common/custom_flat_text_button.dart';

class MoreInfoMenuBody extends StatelessWidget {
  final Playlist playlist = Playlist(
      name: 'ROTATION',
      creator: User(
          name: 'METROSTILE',
          avatarImageUrl:
              'https://cdn.iconscout.com/icon/free/png-512/avatar-370-456322.png'),
      playlistImageUrl:
          'https://i.scdn.co/image/ab67616d0000b273ca086099c509810cb97fd227');

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 48.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _buildPlaylistInfo(),
          Column(
            children: <Widget>[
              CustomFlatTextButton(
                text: 'FOLLOW ON SPOTIFY',
                onPressed: () {},
              ),
              SizedBox(
                height: 16.0,
              ),
              CustomFlatTextButton(
                text: 'SHARE AS LINK',
                onPressed: () {},
              ),
              SizedBox(
                height: 16.0,
              ),
              CustomFlatTextButton(
                text: 'SHARE AS IG STORY',
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    ));
  }

  Column _buildPlaylistInfo() {
    return Column(
      children: <Widget>[
        CircleAvatar(
            radius: 54.0,
            backgroundImage: NetworkImage(playlist.playlistImageUrl)),
        SizedBox(
          height: 16.0,
        ),
        Text(
          playlist.name,
          style: kBannerTextStyle.copyWith(
            letterSpacing: 2.0,
          ),
        ),
        SizedBox(
          height: 3.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Created by', style: kBodyTextStyle.copyWith(fontSize: 14.0)),
            SizedBox(
              width: 8.0,
            ),
            CircleAvatar(
                radius: 14.0,
                backgroundImage: NetworkImage(playlist.creator.avatarImageUrl)),
            SizedBox(
              width: 8.0,
            ),
            Text(playlist.creator.name,
                style: kAvatarTitleTextStyle.copyWith(fontSize: 16.0)),
          ],
        )
      ],
    );
  }
}
