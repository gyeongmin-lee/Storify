import 'package:flutter/material.dart';
import 'package:storify/constants/style.dart';
import 'package:storify/models/user.dart';
import 'package:storify/widgets/_common/custom_flat_text_button.dart';

class MainMenuBody extends StatelessWidget {
  final User user = User(
      name: 'METROSTILE',
      avatarImageUrl:
          'https://cdn.iconscout.com/icon/free/png-512/avatar-370-456322.png');

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Column(
          children: <Widget>[
            CircleAvatar(
                radius: 54.0,
                backgroundImage: NetworkImage(user.avatarImageUrl)),
            SizedBox(
              height: 4.0,
            ),
            Text('Signed in as',
                style: kBodyTextStyle.copyWith(fontSize: 14.0)),
            Text(user.name, style: kAvatarTitleTextStyle),
          ],
        ),
        Column(
          children: <Widget>[
            CustomFlatTextButton(
              text: 'MY PLAYLIST',
              onPressed: () {},
            ),
            SizedBox(
              height: 16.0,
            ),
            CustomFlatTextButton(
              text: 'SIGN OUT',
              onPressed: () {},
            ),
          ],
        ),
      ],
    ));
  }
}
