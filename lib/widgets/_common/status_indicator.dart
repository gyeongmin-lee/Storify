import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:storify/constants/style.dart';

enum Status { loading, error }

class StatusIndicator extends StatelessWidget {
  const StatusIndicator(
      {Key key,
      @required this.status,
      this.errorMessage = 'ERROR',
      this.loadingMessage = 'LOADING'})
      : super(key: key);
  final Status status;
  final String loadingMessage;
  final String errorMessage;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          status == Status.loading
              ? SpinKitFadingCube(
                  size: 36, color: CustomColors.secondaryTextColor)
              : Icon(
                  Icons.error,
                  size: 72,
                  color: Colors.red.withOpacity(0.75),
                ),
          SizedBox(
            height: status == Status.loading ? 24.0 : 8.0,
          ),
          Text(
            status == Status.loading ? loadingMessage : errorMessage,
            style: TextStyles.loadingButtonText.copyWith(
                color: status == Status.loading
                    ? CustomColors.secondaryTextColor
                    : Colors.red),
          )
        ],
      ),
    );
  }
}
