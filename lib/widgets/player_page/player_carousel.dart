import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:storify/models/track.dart';

class PlayerCarousel extends StatelessWidget {
  const PlayerCarousel(
      {Key key, @required this.tracks, @required this.onPageChanged})
      : super(key: key);
  final List<Track> tracks;
  final Function(int index, CarouselPageChangedReason reason) onPageChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: CarouselSlider(
        options: CarouselOptions(
          height: 54.0,
          viewportFraction: 0.20,
          enableInfiniteScroll: false,
          enlargeCenterPage: true,
          enlargeStrategy: CenterPageEnlargeStrategy.height,
          onPageChanged: onPageChanged,
        ),
        items: tracks.map((song) {
          return CircleAvatar(
            radius: 32.0,
            backgroundColor: Colors.transparent,
            child: ClipOval(child: Image.network(song.albumImageUrl)),
          );
        }).toList(),
      ),
    );
  }
}
