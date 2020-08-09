import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class PlayerProgressBar extends StatelessWidget {
  const PlayerProgressBar(
      {Key key,
      @required this.totalValue,
      @required this.initialValue,
      this.onChangeEnd,
      @required this.size,
      this.innerWidget})
      : super(key: key);
  final double totalValue;
  final double initialValue;
  final double size;
  final Widget innerWidget;
  final Function(double) onChangeEnd;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: SleekCircularSlider(
        min: 0,
        max: totalValue,
        initialValue: initialValue,
        appearance: CircularSliderAppearance(
            customColors: CustomSliderColors(
              dotColor: Colors.green,
              progressBarColor: Colors.green,
              trackColor: Colors.white38,
            ),
            size: size,
            angleRange: 360.0,
            startAngle: 0,
            customWidths:
                CustomSliderWidths(trackWidth: 3.0, progressBarWidth: 6.0)),
        onChangeEnd: onChangeEnd,
        innerWidget: (_) => innerWidget,
      ),
    );
  }
}
