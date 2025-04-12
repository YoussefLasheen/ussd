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
  await FirebaseMessaging.instance.subscribeToTopic("flavor_${F.flavor.name}");
  runApp(const App());
}
// flutterfire config  --project=ussd-firebase-project  --out=lib/firebase_options/etisalat.dart --ios-bundle-id=dev.lasheen.ussd.etisalat --ios-out=ios/flavors/etisalat/GoogleService-Info.plist --android-package-name=dev.lasheen.ussd.etisalat
// flutterfire config  --project=ussd-firebase-project  --out=lib/firebase_options/orange.dart --ios-bundle-id=dev.lasheen.ussd.orange --ios-out=ios/flavors/orange/GoogleService-Info.plist --android-package-name=dev.lasheen.ussd.orange
// flutterfire config  --project=ussd-firebase-project  --out=lib/firebase_options/vodafone.dart --ios-bundle-id=dev.lasheen.ussd.vodafone --ios-out=ios/flavors/vodafone/GoogleService-Info.plist --android-package-name=dev.lasheen.ussd.vodafone
// flutterfire config  --project=ussd-firebase-project  --out=lib/firebase_options/we.dart --ios-bundle-id=dev.lasheen.ussd.we --ios-out=ios/flavors/we/GoogleService-Info.plist --android-package-name=dev.lasheen.ussd.we
