import 'package:flutter/material.dart';
import 'package:storify/constants/style.dart';
import 'package:storify/services/spotify_auth.dart';
import 'package:provider/provider.dart';
import 'package:storify/widgets/_common/custom_image_provider.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = context.watch<SpotifyAuth>();

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 160.0, horizontal: 24.0),
        child: Column(
          children: <Widget>[
            CircleAvatar(
                radius: 54.0,
                backgroundColor: Colors.transparent,
                backgroundImage:
                    CustomImageProvider.cachedImage(auth.user.avatarImageUrl)),
            SizedBox(
              height: 8.0,
            ),
            Text('Signed in as',
                style: TextStyles.light.copyWith(fontSize: 14.0)),
            Text(auth.user.name,
                style: TextStyles.primary.copyWith(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5)),
          ],
        ),
      ),
    );
  }
}
