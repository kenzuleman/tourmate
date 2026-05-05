// PLACEHOLDER FILE.
// Run `flutterfire configure` to generate the real one for your Firebase
// project. Until then, the app will throw at startup when it tries to
// initialize Firebase. Replace these placeholder values OR run the CLI:
//
//   dart pub global activate flutterfire_cli
//   flutterfire configure
//
// That will overwrite this file with valid keys for each platform.

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not configured for this platform. '
          'Run `flutterfire configure` to generate them.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCrdU2H2w616LPwSyl152AE5_-CIhJEn-8',
    appId: '1:689526528736:web:143164ff47cefc90fb8e85',
    messagingSenderId: '689526528736',
    projectId: 'tourmate-1772b',
    authDomain: 'tourmate-1772b.firebaseapp.com',
    storageBucket: 'tourmate-1772b.firebasestorage.app',
    measurementId: 'G-NQLGLP08YZ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD8do84vrzs_m9rhhCqlZ6JOX_8TK7pSY8',
    appId: '1:689526528736:android:0a02ae313a30ecc7fb8e85',
    messagingSenderId: '689526528736',
    projectId: 'tourmate-1772b',
    storageBucket: 'tourmate-1772b.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCAYzgCDOXF1j4gUQNwiqeRYgMcQsrB2JM',
    appId: '1:689526528736:ios:36a7bdab7880d9d0fb8e85',
    messagingSenderId: '689526528736',
    projectId: 'tourmate-1772b',
    storageBucket: 'tourmate-1772b.firebasestorage.app',
    iosClientId: '689526528736-lhl53ru4ip7q8qpe0mn40dvjae6tdph8.apps.googleusercontent.com',
    iosBundleId: 'com.example.tourmate',
  );

}