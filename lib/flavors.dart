import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:ussd/firebase_options/etisalat.dart' as etisalat_firebase;
import 'package:ussd/firebase_options/vodafone.dart' as vodafone_firebase;
import 'package:ussd/firebase_options/we.dart' as we_firebase;
import 'package:ussd/firebase_options/orange.dart' as orange_firebase;
import 'package:ussd/models/identity.dart';

enum Flavor {
  vodafone,
  orange,
  we,
  etisalat;

  Identity get identity => switch (this) {
        Flavor.vodafone => const Identity(
            name: 'فودافون',
            color: Color(0xffdf0000),
          ),
        Flavor.orange => const Identity(
            name: 'أورانج',
            color: Color(0xffffa500),
          ),
        Flavor.we => const Identity(
            name: 'WE',
            color: Color(0xff603395),
          ),
        Flavor.etisalat => const Identity(
            name: 'اتصالات',
            color: Color(0xffb22222),
          ),
      };
  FirebaseOptions get firebaseOptions => switch (this) {
        etisalat => etisalat_firebase.DefaultFirebaseOptions.currentPlatform,
        vodafone => vodafone_firebase.DefaultFirebaseOptions.currentPlatform,
        we => we_firebase.DefaultFirebaseOptions.currentPlatform,
        orange => orange_firebase.DefaultFirebaseOptions.currentPlatform,
      };
}

class F {
  static Flavor flavor = Flavor.values.byName(appFlavor!);
  static Identity get identity => flavor.identity;
}
