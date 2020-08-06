import 'package:flutter/material.dart';
import 'package:storify/constants/style.dart';
import 'package:storify/models/artist.dart';
import 'package:storify/models/track.dart';
import 'package:storify/widgets/_common/custom_auto_size_text.dart';
import 'package:storify/widgets/_common/custom_image_provider.dart';

class PlayerTrackInfo extends StatelessWidget {
  const PlayerTrackInfo(
      {Key key,
      @required this.storyText,
      @required this.currentTrack,
      @required this.artistImageUrl})
      : super(key: key);
  final String storyText;
  final Track currentTrack;
  final String artistImageUrl;

  String _artistNames(List<Artist> artists) =>
      artists.map((artist) => artist.name).join(', ');

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 48.0,
            ),
            CircleAvatar(
                radius: 54.0,
                backgroundColor: Colors.transparent,
                backgroundImage:
                    CustomImageProvider.cachedImage(artistImageUrl)),
            SizedBox(
              height: 8.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(children: [
                Text(_artistNames(currentTrack.artists),
                    textAlign: TextAlign.center,
                    style: TextStyles.secondary.copyWith(fontSize: 16.0)),
                CustomAutoSizeText(
                  currentTrack.name,
                  maxLines: 1,
                  minFontSize: 32.0,
                  fontSize: 48.0,
                  overflowReplacement: CustomAutoSizeText(currentTrack.name,
                      maxLines: 2,
                      minFontSize: 32.0,
                      fontSize: 32.0,
                      overflow: TextOverflow.ellipsis),
                ),
              ]),
            ),
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
          ],
        ),
      ),
    );
  }
}
