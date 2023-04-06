// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCq6OdRefxz-ff2MWJlCuyspp2_NlDp0-0',
    appId: '1:431594792101:android:41973882250b63808e194c',
    messagingSenderId: '431594792101',
    projectId: 'storify-cd21c',
    databaseURL: 'https://storify-cd21c.firebaseio.com',
    storageBucket: 'storify-cd21c.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCLXmagLkg9brZoFpmJOimTlO2T1uF07gA',
    appId: '1:431594792101:ios:dcf6632fb8cf39bd8e194c',
    messagingSenderId: '431594792101',
    projectId: 'storify-cd21c',
    databaseURL: 'https://storify-cd21c.firebaseio.com',
    storageBucket: 'storify-cd21c.appspot.com',
    iosClientId:
        '431594792101-0jdi6fs8e0h3953vf4oge7p15mik3ke7.apps.googleusercontent.com',
    iosBundleId: 'com.example.storify',
  );
}
