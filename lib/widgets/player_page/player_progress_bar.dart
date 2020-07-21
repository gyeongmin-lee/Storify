import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class PlayerProgressBar extends StatelessWidget {
  const PlayerProgressBar(
      {Key key,
      @required this.totalValue,
      @required this.initialValue,
      @required this.onChangeEnd})
      : super(key: key);
  final double totalValue;
  final double initialValue;
  final Function(double) onChangeEnd;

  @override
  Widget build(BuildContext context) {
    return SleekCircularSlider(
      min: 0,
      max: totalValue,
      initialValue: initialValue,
      appearance: CircularSliderAppearance(
        customColors: CustomSliderColors(
          dotColor: Colors.white,
          progressBarColor: Colors.green,
          trackColor: Colors.white38,
        ),
        size: 80.0,
        angleRange: 360.0,
        startAngle: 0,
      ),
      onChangeEnd: onChangeEnd,
    );
  }
}
