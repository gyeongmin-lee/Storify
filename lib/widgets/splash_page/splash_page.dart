import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:storify/widgets/onboarding_page/onboarding_page.dart';
import 'package:storify/widgets/sign_in_page/sign_in_page.dart';

class SplashPage extends StatefulWidget {
  static const routeName = 'splash';

  @override
  SplashPageState createState() => new SplashPageState();
}

class SplashPageState extends State<SplashPage>
    with AfterLayoutMixin<SplashPage> {
  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('seen') ?? false);

    if (_seen) {
      Navigator.of(context).pushReplacement(
          PageRouteBuilder(pageBuilder: (_, __, ___) => SignInPage()));
    } else {
      Navigator.of(context).pushReplacement(
          PageRouteBuilder(pageBuilder: (_, __, ___) => OnboardingPage()));
    }
  }

  @override
  void afterFirstLayout(BuildContext context) => checkFirstSeen();

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
