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
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
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

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCJ0LPO2I-kcNjsMZKCIiAV9hgWN541xmI',
    appId: '1:198757308599:web:413037f4c439cf85769532',
    messagingSenderId: '198757308599',
    projectId: 'rapid-response-802d3',
    authDomain: 'rapid-response-802d3.firebaseapp.com',
    storageBucket: 'rapid-response-802d3.appspot.com',
    measurementId: 'G-3WV7T3Y733',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB3-XWUh108BvTcdwiuC1jJgTtJGB0H1zQ',
    appId: '1:198757308599:android:65fe518f39f3c266769532',
    messagingSenderId: '198757308599',
    projectId: 'rapid-response-802d3',
    storageBucket: 'rapid-response-802d3.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBCeoYJBJgJJL74yUbbHNToAKlFCTPMFWY',
    appId: '1:198757308599:ios:6bded516b0fc4c45769532',
    messagingSenderId: '198757308599',
    projectId: 'rapid-response-802d3',
    storageBucket: 'rapid-response-802d3.appspot.com',
    iosBundleId: 'com.example.client',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBCeoYJBJgJJL74yUbbHNToAKlFCTPMFWY',
    appId: '1:198757308599:ios:ad23e2a43fa23ccc769532',
    messagingSenderId: '198757308599',
    projectId: 'rapid-response-802d3',
    storageBucket: 'rapid-response-802d3.appspot.com',
    iosBundleId: 'com.example.client.RunnerTests',
  );
}
