import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:ussd/flavors.dart';
import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: F.flavor.firebaseOptions,
  );
  FirebaseMessaging.instance.requestPermission();
  await FirebaseMessaging.instance.subscribeToTopic("flavor${F.flavor.name}");
  runApp(const App());
}
// flutterfire config --android-package-name=dev.lasheen.ussd.etisalat --project=ussd-firebase-project --out=lib/firebase_options/etisalat.dart
// flutterfire config --android-package-name=dev.lasheen.ussd.orange --project=ussd-firebase-project --out=lib/firebase_options/orange.dart
// flutterfire config --android-package-name=dev.lasheen.ussd.vodafone --project=ussd-firebase-project --out=lib/firebase_options/vodafone.dart
// flutterfire config --android-package-name=dev.lasheen.ussd.we --project=ussd-firebase-project --out=lib/firebase_options/we.dart
