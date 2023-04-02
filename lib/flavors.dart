import 'package:flutter/material.dart';
import 'package:ussd/constants.dart';
import 'package:ussd/models/code.dart';

enum Flavor {
  vodafone,
  orange,
}

class F {
  static Flavor? appFlavor;

  static String get name => appFlavor?.name ?? '';

  //Add color getter
  static Color get color {
    switch (appFlavor) {
      case Flavor.vodafone:
        return Colors.red;
      case Flavor.orange:
        return Colors.orange;
      default:
        return Colors.black;
    }
  }

  static String get title {
    switch (appFlavor) {
      case Flavor.vodafone:
        return 'Vodafone Cash';
      case Flavor.orange:
        return 'Orange Cash';
      default:
        return 'title';
    }
  }

  //Add codes getter
  static List<Code> get code {
    switch (appFlavor) {
      case Flavor.vodafone:
        return vodafoneCodes;
      case Flavor.orange:
        return orangeCodes;
      default:
        return [];
    }
  }
}
