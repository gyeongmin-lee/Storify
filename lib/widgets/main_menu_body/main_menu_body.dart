import 'package:flutter/material.dart';
import 'package:storify/constants/style.dart';
import 'package:storify/models/user.dart';
import 'package:storify/widgets/_common/custom_flat_text_button.dart';

class MainMenuBody extends StatelessWidget {
  const MainMenuBody({Key key, @required this.user}) : super(key: key);
  final User user;

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Padding(
      padding: const EdgeInsets.symmetric(vertical: 96.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            children: <Widget>[
              CircleAvatar(
                  radius: 54.0,
                  backgroundColor: Colors.transparent,
                  backgroundImage: NetworkImage(user.avatarImageUrl)),
              SizedBox(
                height: 8.0,
              ),
              Text('Signed in as',
                  style: TextStyles.light.copyWith(fontSize: 14.0)),
              Text(user.name,
                  style: TextStyles.primary.copyWith(fontSize: 22.0)),
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
      ),
    ));
  }
}
