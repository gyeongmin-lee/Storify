import 'package:flutter/material.dart';
import 'package:share/share.dart';
import 'package:storify/constants/style.dart';
import 'package:storify/models/playlist.dart';
import 'package:storify/services/spotify_api.dart';
import 'package:storify/widgets/_common/custom_flat_text_button.dart';
import 'package:storify/widgets/_common/custom_image_provider.dart';
import 'package:storify/widgets/_common/custom_toast.dart';
import 'package:storify/widgets/_common/overlay_modal.dart';
import 'package:url_launcher/url_launcher.dart';

class MoreInfoMenuBody extends StatelessWidget {
  const MoreInfoMenuBody({Key key, @required this.playlist}) : super(key: key);
  final Playlist playlist;

  void _onOpenInSpotify() async {
    final url = playlist.externalUrl;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      CustomToast.showTextToast(
          text: 'Failed to open spotify link', toastType: ToastType.error);
    }
  }

  void _onShareAsLink() async {
    final isPublic = await SpotifyApi.getPlaylist(playlist.id)
        .then((playlist) => playlist.isPublic);
    if (isPublic) {
      final url = playlist.deepLinkUri;
      Share.share(url, subject: 'Open "${playlist.name}" in Storify');
    } else {
      OverlayModal.show(
          icon: Icon(
            Icons.warning,
            color: Colors.orange,
            size: 72.0,
          ),
          message:
              'You can only share a public playlist. Open spotify and make your playlist "Public"',
          actionText: 'OPEN SPOTIFY',
          onConfirm: () async {
            final url = playlist.externalUrl;
            if (await canLaunch(url)) {
              await launch(url);
            } else {
              CustomToast.showTextToast(
                text: 'Failed to open spotify link',
                toastType: ToastType.error,
              );
            }
          });
    }
  }

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
                onPressed: _onOpenInSpotify,
              ),
              SizedBox(
                height: 16.0,
              ),
              CustomFlatTextButton(
                text: 'SHARE AS LINK',
                onPressed: _onShareAsLink,
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

  Column _buildPlaylistInfo() {
    return Column(
      children: <Widget>[
        CircleAvatar(
            radius: 54.0,
            backgroundColor: Colors.transparent,
            backgroundImage:
                CustomImageProvider.cachedImage(playlist.playlistImageUrl)),
        SizedBox(
          height: 16.0,
        ),
        Text(
          playlist.name,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: TextStyles.bannerText.copyWith(letterSpacing: 0.0),
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
                backgroundImage: CustomImageProvider.cachedImage(
                    playlist.owner.avatarImageUrl)),
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
