import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:storify/models/track.dart';
import 'package:storify/utils/repeater.dart';
import 'package:storify/constants/values.dart' as Constants;

class PlayerCarousel extends StatefulWidget {
  const PlayerCarousel(
      {Key key,
      @required this.tracks,
      @required this.onPageChanged,
      this.onPlayButtonTap,
      @required this.carouselController})
      : super(key: key);
  final List<Track> tracks;
  final Function(int index) onPageChanged;
  final Function() onPlayButtonTap;
  final CarouselController carouselController;

  @override
  _PlayerCarouselState createState() => _PlayerCarouselState();
}

class _PlayerCarouselState extends State<PlayerCarousel> {
  int _selectedTrackIndex = 0;

  Future<void> _onTrackTapped(Track tappedtrack) async {
    final indexToNavigate =
        widget.tracks.indexWhere((track) => track.id == tappedtrack.id);
    final trackOffset = indexToNavigate - _selectedTrackIndex;

    if (trackOffset == 0) {
      widget.onPlayButtonTap?.call();
      return;
    }

    await Repeater.repeat(
        callback: trackOffset > 0
            ? () => widget.carouselController
                .nextPage(duration: Constants.carouselAnimationDuration)
            : () => widget.carouselController
                .previousPage(duration: Constants.carouselAnimationDuration),
        repeatNumber: (trackOffset).abs(),
        repeatDuration: Constants.carouselAnimationDuration);
  }

  void _handlePageChange(int index, CarouselPageChangedReason reason) {
    setState(() {
      _selectedTrackIndex = index;
    });
    widget.onPageChanged(index);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: CarouselSlider(
        carouselController: widget.carouselController,
        options: CarouselOptions(
          height: 54.0,
          viewportFraction: 0.20,
          enableInfiniteScroll: false,
          enlargeCenterPage: true,
          enlargeStrategy: CenterPageEnlargeStrategy.height,
          onPageChanged: _handlePageChange,
        ),
        items: widget.tracks.map((track) {
          return GestureDetector(
            onTap: () => _onTrackTapped(track),
            child: CircleAvatar(
              radius: 32.0,
              backgroundColor: Colors.transparent,
              child: ClipOval(child: Image.network(track.albumImageUrl)),
            ),
          );
        }).toList(),
      ),
    );
  }
}
