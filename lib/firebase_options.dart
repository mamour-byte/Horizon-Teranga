// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import "package:firebase_core/firebase_core.dart" show FirebaseOptions;
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
        return windows;
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
    apiKey: 'AIzaSyCgFTpFY5GNJGvB82oIY31HIhw5BgL96UE',
    appId: '1:641051720841:web:dc1aece693803ce0ef5a58',
    messagingSenderId: '641051720841',
    projectId: 'horizon-teranga',
    authDomain: 'horizon-teranga.firebaseapp.com',
    storageBucket: 'horizon-teranga.appspot.com',
    measurementId: 'G-H3XW84E5T1',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA0hv0oojiFPjW_YR67OqCY7vvAC4QUGjI',
    appId: '1:641051720841:android:0891672f6173fbccef5a58',
    messagingSenderId: '641051720841',
    projectId: 'horizon-teranga',
    storageBucket: 'horizon-teranga.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCFO1QOIpyWF8BZjt2IQtpSaGoeXCMwJxs',
    appId: '1:641051720841:ios:e63191c16610c8deef5a58',
    messagingSenderId: '641051720841',
    projectId: 'horizon-teranga',
    storageBucket: 'horizon-teranga.appspot.com',
    iosBundleId: 'com.example.horizonteranga',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCFO1QOIpyWF8BZjt2IQtpSaGoeXCMwJxs',
    appId: '1:641051720841:ios:e63191c16610c8deef5a58',
    messagingSenderId: '641051720841',
    projectId: 'horizon-teranga',
    storageBucket: 'horizon-teranga.appspot.com',
    iosBundleId: 'com.example.horizonteranga',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCgFTpFY5GNJGvB82oIY31HIhw5BgL96UE',
    appId: '1:641051720841:web:01693699359f38c1ef5a58',
    messagingSenderId: '641051720841',
    projectId: 'horizon-teranga',
    authDomain: 'horizon-teranga.firebaseapp.com',
    storageBucket: 'horizon-teranga.appspot.com',
    measurementId: 'G-K85215VMRT',
  );

}