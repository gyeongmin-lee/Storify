import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storify/constants/style.dart';
import 'package:storify/widgets/sign_in_page/sign_in_page.dart';

import 'custom_page_view_model.dart';

class OnboardingPage extends StatelessWidget {
  static const routeName = '/onboarding';

  final List<PageViewModel> listPagesViewModel = [
    CustomPageViewModel.create(
        titleText: 'Add captions to songs in your Spotify playlist',
        bodyText:
            'Provide context to your Spotify playlists by adding captions to each tracks in your playlists.',
        imagePath: 'images/audio_player.svg'),
    CustomPageViewModel.create(
        titleText: 'Share your playlist',
        bodyText:
            'After adding captions to your tracks, share your Spotify playlist to your friends by sending them a link.',
        imagePath: 'images/share_link.svg'),
    CustomPageViewModel.create(
        titleText: 'Browse playlists',
        bodyText:
            'Browse Spotify playlists created by other users, and read through captions for each tracks',
        imagePath: 'images/compose_music.svg')
  ];

  @override
  Widget build(BuildContext context) {
    return IntroductionScreen(
      pages: listPagesViewModel,
      next: Text(
        "Next",
        style: TextStyles.primary.copyWith(fontSize: 16.0),
      ),
      done: Text(
        "Done",
        style: TextStyles.primary.copyWith(fontSize: 16.0),
      ),
      dotsDecorator: DotsDecorator(
          activeColor: Colors.green,
          color: Colors.white38,
          size: Size.square(6.0)),
      onDone: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool('seen', true);
        Navigator.of(context).popAndPushNamed(SignInPage.routeName);
      },
    );
  }
}
