import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storify/constants/style.dart';
import 'package:storify/services/spotify_auth.dart';
import 'package:storify/widgets/_common/custom_toast.dart';
import 'package:storify/widgets/about_page/about_page.dart';
import 'package:storify/widgets/sign_in_page/sign_in_page.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePage extends StatelessWidget {
  void _openSpotify() async {
    final url = 'http://open.spotify.com/';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      CustomToast.showTextToast(
          text: 'Failed to open spotify link', toastType: ToastType.error);
    }
  }

  void _openFeedback() async {
    final url = 'https://forms.gle/BS2SbHL6uHjfgh3X8';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      CustomToast.showTextToast(
          text: 'Failed to open feedback link', toastType: ToastType.error);
    }
  }

  void _onSignout(BuildContext context) {
    final navigator = Navigator.of(context);
    navigator.push(MaterialPageRoute(
      builder: (context) => SignInPage(),
    ));

    final auth = context.read<SpotifyAuth>();
    auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<SpotifyAuth>();
    final avatarImageUrl = auth.user?.avatarImageUrl;

    return SafeArea(
      child: Center(
        child: Column(
          children: [
            ListTile(
              contentPadding:
                  EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
              leading: Container(
                height: 48.0,
                width: 48.0,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: CircleAvatar(
                    radius: 54.0,
                    backgroundColor: Colors.transparent,
                    backgroundImage: avatarImageUrl != null
                        ? CachedNetworkImageProvider(avatarImageUrl)
                        : null),
              ),
              title: Text(auth.user!.name!,
                  style: TextStyles.primary.copyWith(
                      fontSize: 30.0,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5)),
            ),
            Divider(
              color: Colors.white10,
              thickness: 1.0,
              height: 1.0,
            ),
            ListTile(
              leading: Image.asset(
                'images/spotify.png',
                width: 24.0,
              ),
              title: Text('Open Spotify',
                  style:
                      TextStyles.primary.copyWith(fontWeight: FontWeight.bold)),
              onTap: _openSpotify,
            ),
            ListTile(
              leading: Icon(
                Icons.send,
                color: CustomColors.primaryTextColor,
              ),
              title: Text('Send Feedback',
                  style:
                      TextStyles.primary.copyWith(fontWeight: FontWeight.bold)),
              onTap: _openFeedback,
            ),
            ListTile(
              leading: Icon(
                Icons.info,
                color: CustomColors.primaryTextColor,
              ),
              title: Text('About',
                  style:
                      TextStyles.primary.copyWith(fontWeight: FontWeight.bold)),
              onTap: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => AboutPage(),
              )),
            ),
            ListTile(
                leading: Icon(
                  Icons.logout,
                  color: CustomColors.primaryTextColor,
                ),
                title: Text('Log out',
                    style: TextStyles.primary
                        .copyWith(fontWeight: FontWeight.bold)),
                onTap: () => _onSignout(context)),
          ],
        ),
      ),
    );
  }
}
