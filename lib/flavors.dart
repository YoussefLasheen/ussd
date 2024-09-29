import 'package:flutter/services.dart';
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
}

class F {
  static Flavor flavor = Flavor.values.byName(appFlavor!);
  static Identity get identity => flavor.identity;
}
