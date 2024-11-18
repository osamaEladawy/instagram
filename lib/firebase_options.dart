// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
    apiKey: 'AIzaSyDwrTNYsBf9Y2ov4zr9qY5fmiRobjZ6GCs',
    appId: '1:465195890091:web:26c14cc9c4acedf56aceee',
    messagingSenderId: '465195890091',
    projectId: 'inista-c71ef',
    authDomain: 'inista-c71ef.firebaseapp.com',
    storageBucket: 'inista-c71ef.appspot.com',
    measurementId: 'G-NSMPRLWYJB',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBKovNQMd5XnYIeAR058tvKroWWSCBu3vw',
    appId: '1:465195890091:android:5b6a4f8afd5363616aceee',
    messagingSenderId: '465195890091',
    projectId: 'inista-c71ef',
    storageBucket: 'inista-c71ef.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyAFACseEK55bmWLQLv8P_keQq_FZxKdDj0',
    appId: '1:465195890091:ios:77eae47b4095a17a6aceee',
    messagingSenderId: '465195890091',
    projectId: 'inista-c71ef',
    storageBucket: 'inista-c71ef.appspot.com',
    iosClientId: '465195890091-o0aesbkg3ju35m14p2biq03ri7k83vif.apps.googleusercontent.com',
    iosBundleId: 'com.classcar200.inistagram',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyAFACseEK55bmWLQLv8P_keQq_FZxKdDj0',
    appId: '1:465195890091:ios:77eae47b4095a17a6aceee',
    messagingSenderId: '465195890091',
    projectId: 'inista-c71ef',
    storageBucket: 'inista-c71ef.appspot.com',
    iosClientId: '465195890091-o0aesbkg3ju35m14p2biq03ri7k83vif.apps.googleusercontent.com',
    iosBundleId: 'com.classcar200.inistagram',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDwrTNYsBf9Y2ov4zr9qY5fmiRobjZ6GCs',
    appId: '1:465195890091:web:a98382138ef5efd46aceee',
    messagingSenderId: '465195890091',
    projectId: 'inista-c71ef',
    authDomain: 'inista-c71ef.firebaseapp.com',
    storageBucket: 'inista-c71ef.appspot.com',
    measurementId: 'G-V1F155JTNG',
  );
}