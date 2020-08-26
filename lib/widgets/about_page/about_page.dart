import 'dart:io';

import 'package:flutter/material.dart';
import 'package:storify/constants/style.dart';
import 'package:storify/widgets/_common/custom_toast.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  void _showProfile() async {
    final url = 'https://github.com/gyeongmin-lee';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      CustomToast.showTextToast(
          text: 'Failed to open link', toastType: ToastType.error);
    }
  }

  void _showRatingPage() async {
    var url = Platform.isAndroid
        ? 'https://play.google.com/store/apps/details?id=com.minlee.storify'
        : 'https://play.google.com/store/apps/details?id=com.minlee.storify';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      CustomToast.showTextToast(
          text: 'Failed to open link', toastType: ToastType.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            ListTile(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              leading: Image.asset(
                'images/logo.png',
                width: 64.0,
              ),
              title: Text('Storify',
                  style: TextStyles.primary
                      .copyWith(fontWeight: FontWeight.bold, fontSize: 20.0)),
              subtitle: Text(
                'Add captions to your Spotify playlists',
                style: TextStyles.secondary.copyWith(fontSize: 16.0),
              ),
            ),
            Divider(
              color: Colors.white10,
              thickness: 1.0,
              height: 1.0,
            ),
            ListTile(
              leading: Icon(
                Icons.star,
                color: CustomColors.primaryTextColor,
              ),
              title: Text('Rate our app',
                  style: TextStyles.primary
                      .copyWith(fontWeight: FontWeight.bold, fontSize: 16.0)),
              onTap: _showRatingPage,
            ),
            ListTile(
              leading: Icon(
                Icons.person,
                color: CustomColors.primaryTextColor,
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Developer profile',
                      style: TextStyles.primary.copyWith(
                          fontWeight: FontWeight.bold, fontSize: 16.0)),
                  Text('Created by Gyeongmin Lee',
                      style: TextStyles.secondary.copyWith(fontSize: 14.0))
                ],
              ),
              onTap: _showProfile,
            )
          ],
        ),
      ),
    );
  }
}
