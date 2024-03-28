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
    apiKey: 'AIzaSyDkz6dh1a8xQJsd-1JNwRdI5-VD42Wmois',
    appId: '1:859967241146:web:56130f42f7f3ae81137b83',
    messagingSenderId: '859967241146',
    projectId: 'fasum-app-1d76a',
    authDomain: 'fasum-app-1d76a.firebaseapp.com',
    storageBucket: 'fasum-app-1d76a.appspot.com',
    measurementId: 'G-KBXB1MHTY2',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBWfp6DXxggE_PEHd0RxpICHv50danyN-c',
    appId: '1:859967241146:android:05b6580ce894d657137b83',
    messagingSenderId: '859967241146',
    projectId: 'fasum-app-1d76a',
    storageBucket: 'fasum-app-1d76a.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDgcd05qoSwbv3XNDZLMNCdRE78ODz1vqI',
    appId: '1:859967241146:ios:117d8689c7681436137b83',
    messagingSenderId: '859967241146',
    projectId: 'fasum-app-1d76a',
    storageBucket: 'fasum-app-1d76a.appspot.com',
    iosBundleId: 'com.example.fasumApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDgcd05qoSwbv3XNDZLMNCdRE78ODz1vqI',
    appId: '1:859967241146:ios:73cc7e1e73f8ea82137b83',
    messagingSenderId: '859967241146',
    projectId: 'fasum-app-1d76a',
    storageBucket: 'fasum-app-1d76a.appspot.com',
    iosBundleId: 'com.example.fasumApp.RunnerTests',
  );
}