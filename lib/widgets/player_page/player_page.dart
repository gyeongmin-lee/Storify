import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:storify/constants/style.dart';
import 'package:storify/constants/values.dart' as CONST_VALUES;
import 'package:storify/models/artist.dart';
import 'package:storify/models/playlist.dart';
import 'package:storify/models/track.dart';
import 'package:storify/services/spotify_auth.dart';
import 'package:storify/widgets/_common/custom_flat_icon_button.dart';
import 'package:storify/widgets/_common/custom_rounded_button.dart';
import 'package:storify/widgets/_common/overlay_menu.dart';
import 'package:storify/widgets/edit_story_page/edit_story_page.dart';
import 'package:storify/widgets/main_menu_body/main_menu_body.dart';
import 'package:storify/widgets/more_info_menu_body/more_info_menu_body.dart';
import 'package:storify/widgets/player_page/player_carousel.dart';
import 'package:storify/widgets/player_page/player_progress_bar.dart';
import 'package:provider/provider.dart';

class PlayerPage extends StatefulWidget {
  static const routeName = '/player';

  @override
  _PlayerState createState() => _PlayerState();
}

class _PlayerState extends State<PlayerPage> {
  Playlist playlist = Playlist(name: 'John\'s playlist');
  Track track = Track(
      name: 'Hmmm',
      artist: Artist(
          name: 'Ready',
          artistImageUrl:
              'https://cdn.icon-icons.com/icons2/1736/PNG/512/4043260-avatar-male-man-portrait_113269.png'),
      albumImageUrl:
          'https://image.genie.co.kr/Y/IMAGE/IMG_ALBUM/081/443/375/81443375_1589523123165_1_600x600.JPG');
  List<Track> tracks = [
    Track(
        name: 'DNA',
        artist: Artist(
            name: 'Ready',
            artistImageUrl:
                'https://cdn.icon-icons.com/icons2/1736/PNG/512/4043260-avatar-male-man-portrait_113269.png'),
        albumImageUrl:
            'https://i.scdn.co/image/ab67616d0000b2738b52c6b9bc4e43d873869699'),
    Track(
        name: 'Hmmm',
        artist: Artist(
            name: 'Ready',
            artistImageUrl:
                'https://cdn.icon-icons.com/icons2/1736/PNG/512/4043260-avatar-male-man-portrait_113269.png'),
        albumImageUrl:
            'https://image.genie.co.kr/Y/IMAGE/IMG_ALBUM/081/443/375/81443375_1589523123165_1_600x600.JPG'),
    Track(
        name: 'Street Lights',
        artist: Artist(
            name: 'Ready',
            artistImageUrl:
                'https://cdn.icon-icons.com/icons2/1736/PNG/512/4043260-avatar-male-man-portrait_113269.png'),
        albumImageUrl:
            'https://i.scdn.co/image/ab67616d0000b273346d77e155d854735410ed18'),
    Track(
        name: 'Power Out',
        artist: Artist(
            name: 'Ready',
            artistImageUrl:
                'https://cdn.icon-icons.com/icons2/1736/PNG/512/4043260-avatar-male-man-portrait_113269.png'),
        albumImageUrl:
            'https://i.scdn.co/image/ab67616d0000b2737870762a58313ad6f981d664'),
    Track(
        name: 'D',
        artist: Artist(
            name: 'Ready',
            artistImageUrl:
                'https://cdn.icon-icons.com/icons2/1736/PNG/512/4043260-avatar-male-man-portrait_113269.png'),
        albumImageUrl:
            'https://img.discogs.com/vgOs5VD52OlkimY2PJQyxi4Qy8s=/fit-in/600x600/filters:strip_icc():format(jpeg):mode_rgb():quality(90)/discogs-images/R-8845908-1469984148-2294.jpeg.jpg'),
    Track(
        name: 'NAPPA',
        artist: Artist(
            name: 'Ready',
            artistImageUrl:
                'https://cdn.icon-icons.com/icons2/1736/PNG/512/4043260-avatar-male-man-portrait_113269.png'),
        albumImageUrl:
            'https://i.scdn.co/image/ab67616d0000b2739efc75bc81022179079b0b6b'),
  ];
  String storyText = '';

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (tracks.length < CONST_VALUES.prefetchImageLimit) {
        tracks.forEach((track) {
          precacheImage(
              CachedNetworkImageProvider(track.albumImageUrl), context);
        });
      }
    });
    super.initState();
  }

  void _onEditOrAddPressed() {
    EditStoryPage.show(context,
        track: track,
        originalStoryText: storyText,
        onStoryTextEdited: (newValue) => setState(() => storyText = newValue));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.network(
          track.albumImageUrl,
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
                style: TextStyles.appBarTitle.copyWith(letterSpacing: 0),
              ),
              centerTitle: true,
              elevation: 0,
              backgroundColor: Colors.transparent,
              leading: CustomFlatIconButton(
                  icon: Icon(
                    Icons.menu,
                    color: TextStyles.appBarTitle.color,
                  ),
                  onPressed: () => OverlayMenu.show(context,
                      menuBody: MainMenuBody(
                        auth: context.read<SpotifyAuth>(),
                      ))),
              actions: <Widget>[
                FlatButton(
                  child: Text(
                    'MORE',
                    style: TextStyles.smallButtonText,
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
    return Padding(
      padding: const EdgeInsets.only(top: 80.0, bottom: 36.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              // TODO Display arrow if scroll
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: 48.0,
                  ),
                  CircleAvatar(
                      radius: 54.0,
                      backgroundColor: Colors.transparent,
                      backgroundImage: track.artist.artistImageUrl != null
                          ? CachedNetworkImageProvider(
                              track.artist.artistImageUrl)
                          : null),
                  SizedBox(
                    height: 8.0,
                  ),
                  Text(track.artist.name,
                      style: TextStyles.secondary.copyWith(fontSize: 16.0)),
                  Text(track.name,
                      style: TextStyles.primary.copyWith(
                          fontSize: 60.0,
                          fontWeight: FontWeight.w600,
                          height: 1.1,
                          letterSpacing: -1.5)),
                  SizedBox(
                    height: 16.0,
                  ),
                  if (storyText != '')
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 24.0),
                      width: double.infinity,
                      child: Text(
                        storyText,
                        textAlign: TextAlign.start,
                        style: TextStyles.secondary
                            .copyWith(fontSize: 18.0, height: 1.5),
                      ),
                    ),
                  if (storyText == '')
                    CustomRoundedButton(
                      size: ButtonSize.small,
                      buttonText: 'ADD A STORY',
                      onPressed: _onEditOrAddPressed,
                    )
                ],
              ),
            ),
          ),
          Column(children: [
            if (storyText != '')
              Column(children: [
                SizedBox(
                  height: 16.0,
                ),
                CustomRoundedButton(
                  size: ButtonSize.small,
                  buttonText: 'EDIT YOUR STORY',
                  onPressed: _onEditOrAddPressed,
                ),
                SizedBox(
                  height: 16.0,
                )
              ]),
            Stack(
              alignment: AlignmentDirectional.center,
              children: <Widget>[
                PlayerCarousel(tracks: tracks),
                PlayerProgressBar(
                  totalValue: 360,
                  initialValue: 270,
                  size: 72.0,
                ),
              ],
            )
          ])
        ],
      ),
    );
  }
}
