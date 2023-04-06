import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:storify/constants/style.dart';

enum Status { loading, error, warning }

class StatusIndicator extends StatelessWidget {
  const StatusIndicator({
    Key? key,
    required this.status,
    required this.message,
  }) : super(key: key);
  final Status status;
  final String message;

  Map<Status, Map<String, dynamic>> get statusItems => {
        Status.error: {
          'text_color': Colors.red,
          'icon': Icon(
            Icons.error,
            size: 72,
            color: Colors.red.withOpacity(0.75),
          ),
          'spacing': 8.0
        },
        Status.warning: {
          'text_color': Colors.orange,
          'icon': Icon(
            Icons.inbox,
            size: 72,
            color: Colors.orange.withOpacity(0.75),
          ),
          'spacing': 8.0
        },
        Status.loading: {
          'text_color': CustomColors.secondaryTextColor,
          'icon': SpinKitFadingCube(
              size: 36, color: CustomColors.secondaryTextColor),
          'spacing': 24.0
        }
      };

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          statusItems[status]!['icon'],
          SizedBox(
            height: statusItems[status]!['spacing'],
          ),
          Text(message,
              textAlign: TextAlign.center,
              style: TextStyles.loadingButtonText.copyWith(
                  color: statusItems[status]!['text_color'], height: 1.3))
        ],
      ),
    );
  }
}
