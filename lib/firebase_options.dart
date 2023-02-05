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
    apiKey: 'AIzaSyDx_0SXRF52vYyiv7XUjA-Eush-try-dtw',
    appId: '1:481675954776:web:56ddabd176383df39d182d',
    messagingSenderId: '481675954776',
    projectId: 'travely-376605',
    authDomain: 'travely-376605.firebaseapp.com',
    databaseURL: 'https://travely-376605-default-rtdb.firebaseio.com',
    storageBucket: 'travely-376605.appspot.com',
    measurementId: 'G-MM6F29B6E1',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDwBOWV_E5U2awBTwtkulJkhsBdeKmEpgg',
    appId: '1:481675954776:android:14401e489c5bcc329d182d',
    messagingSenderId: '481675954776',
    projectId: 'travely-376605',
    databaseURL: 'https://travely-376605-default-rtdb.firebaseio.com',
    storageBucket: 'travely-376605.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDAK5SIqmHfmc397rOotIT4FgMegv3-xQw',
    appId: '1:481675954776:ios:0c39b19992837ab69d182d',
    messagingSenderId: '481675954776',
    projectId: 'travely-376605',
    databaseURL: 'https://travely-376605-default-rtdb.firebaseio.com',
    storageBucket: 'travely-376605.appspot.com',
    iosBundleId: 'com.example.travely',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDAK5SIqmHfmc397rOotIT4FgMegv3-xQw',
    appId: '1:481675954776:ios:0c39b19992837ab69d182d',
    messagingSenderId: '481675954776',
    projectId: 'travely-376605',
    databaseURL: 'https://travely-376605-default-rtdb.firebaseio.com',
    storageBucket: 'travely-376605.appspot.com',
    iosBundleId: 'com.example.travely',
  );
}
