import 'package:flutter/material.dart';
import 'package:storify/constants/style.dart';
import 'package:storify/services/spotify_auth.dart';
import 'package:storify/widgets/_common/custom_flat_text_button.dart';
import 'package:storify/widgets/_common/custom_image_provider.dart';
import 'package:storify/widgets/my_playlists_page/my_playlists_page.dart';

class MainMenuBody extends StatelessWidget {
  const MainMenuBody({Key key, @required this.auth}) : super(key: key);
  final SpotifyAuth auth;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 96.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            children: <Widget>[
              CircleAvatar(
                  radius: 54.0,
                  backgroundColor: Colors.transparent,
                  backgroundImage: CustomImageProvider.cachedImage(
                      auth.user.avatarImageUrl)),
              SizedBox(
                height: 8.0,
              ),
              Text('Signed in as',
                  style: TextStyles.light.copyWith(fontSize: 14.0)),
              Text(auth.user.name,
                  style: TextStyles.primary.copyWith(fontSize: 22.0)),
            ],
          ),
          Column(
            children: <Widget>[
              CustomFlatTextButton(
                text: 'MY PLAYLISTS',
                onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(
                    MyPlaylistsPage.routeName, (Route<dynamic> route) => false),
              ),
              SizedBox(
                height: 16.0,
              ),
            ],
          ),
        ],
      ),
    ));
  }
}
