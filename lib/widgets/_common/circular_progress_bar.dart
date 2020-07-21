import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class CircularProgressBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SleekCircularSlider(
        min: 0,
        max: 360,
        initialValue: 270,
        appearance: CircularSliderAppearance(
            customColors: CustomSliderColors(
              dotColor: Colors.white,
              progressBarColor: Colors.green,
              trackColor: Colors.white38,
            ),
            size: 80.0,
            angleRange: 360.0,
            startAngle: 0,
            customWidths: CustomSliderWidths()),
        onChange: (double value) {
          print(value);
        });
  }
}
