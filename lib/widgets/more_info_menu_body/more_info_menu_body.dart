import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:storify/constants/style.dart';
import 'package:storify/models/playlist.dart';
import 'package:storify/models/user.dart';
import 'package:storify/widgets/_common/custom_flat_text_button.dart';

class MoreInfoMenuBody extends StatelessWidget {
  final Playlist playlist = Playlist(
      externalUrl: '',
      id: '',
      isPublic: true,
      numOfTracks: 10,
      name: 'ROTATION',
      owner: User(
          id: '',
          name: 'METROSTILE',
          avatarImageUrl:
              'https://cdn.iconscout.com/icon/free/png-512/avatar-370-456322.png'),
      playlistImageUrl:
          'https://i.scdn.co/image/ab67616d0000b273ca086099c509810cb97fd227');

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 96.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          _buildPlaylistInfo(),
          Column(
            children: <Widget>[
              CustomFlatTextButton(
                text: 'OPEN IN SPOTIFY',
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
            backgroundColor: Colors.transparent,
            backgroundImage: playlist.playlistImageUrl != null
                ? CachedNetworkImageProvider(playlist.playlistImageUrl)
                : null),
        SizedBox(
          height: 16.0,
        ),
        Text(
          playlist.name,
          style: TextStyles.bannerText.copyWith(
            letterSpacing: 2.0,
          ),
        ),
        SizedBox(
          height: 3.0,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Created by',
                style: TextStyles.light.copyWith(fontSize: 14.0)),
            SizedBox(
              width: 8.0,
            ),
            CircleAvatar(
                radius: 14.0,
                backgroundColor: Colors.transparent,
                backgroundImage: playlist.owner.avatarImageUrl != null
                    ? CachedNetworkImageProvider(playlist.owner.avatarImageUrl)
                    : null),
            SizedBox(
              width: 8.0,
            ),
            Text(playlist.owner.name,
                style: TextStyles.primary.copyWith(fontSize: 16.0)),
          ],
        )
      ],
    );
  }
}
