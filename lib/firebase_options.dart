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
    apiKey: 'AIzaSyDdX72lgHnS6MWBhYihQWt1rZDg9xUqnBI',
    appId: '1:925956866229:web:5c2b6d0718f835628efefc',
    messagingSenderId: '925956866229',
    projectId: 'pm-1---task-management-9cfba',
    authDomain: 'pm-1---task-management-9cfba.firebaseapp.com',
    storageBucket: 'pm-1---task-management-9cfba.appspot.com',
    measurementId: 'G-BP7T7BWYGM',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAKPB4-0lY25Rto6ZtmgSyzjCGkH6knpsA',
    appId: '1:925956866229:android:c1106781c99b473e8efefc',
    messagingSenderId: '925956866229',
    projectId: 'pm-1---task-management-9cfba',
    storageBucket: 'pm-1---task-management-9cfba.appspot.com',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDdX72lgHnS6MWBhYihQWt1rZDg9xUqnBI',
    appId: '1:925956866229:web:e239a68860e9b6308efefc',
    messagingSenderId: '925956866229',
    projectId: 'pm-1---task-management-9cfba',
    authDomain: 'pm-1---task-management-9cfba.firebaseapp.com',
    storageBucket: 'pm-1---task-management-9cfba.appspot.com',
    measurementId: 'G-22385GMTEH',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCXm1pqAMJ_6m8Obonz35Wnsk3oqS4sUR8',
    appId: '1:925956866229:ios:5ee38795b1b83e738efefc',
    messagingSenderId: '925956866229',
    projectId: 'pm-1---task-management-9cfba',
    storageBucket: 'pm-1---task-management-9cfba.appspot.com',
    iosBundleId: 'com.example.utsWarteg',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCXm1pqAMJ_6m8Obonz35Wnsk3oqS4sUR8',
    appId: '1:925956866229:ios:5ee38795b1b83e738efefc',
    messagingSenderId: '925956866229',
    projectId: 'pm-1---task-management-9cfba',
    storageBucket: 'pm-1---task-management-9cfba.appspot.com',
    iosBundleId: 'com.example.utsWarteg',
  );

}