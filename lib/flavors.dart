import 'package:flutter/material.dart';

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
}
