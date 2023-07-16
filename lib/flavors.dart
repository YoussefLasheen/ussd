import 'package:flutter/material.dart';
import 'package:ussd/constants.dart';
import 'package:ussd/models/code.dart';

enum Flavor {
  vodafone,
  orange,
  we,
  etisalat,
}

class F {
  static Flavor? appFlavor;

  static String get name => appFlavor?.name ?? '';

  //Add color getter
  static Color get color {
    return Color(identity[name]['color']);
  }

  static String get title {
    return identity[name]['name']; 
  }

  //Add codes getter
  static List<CodeSection> get code {
    return identity[name]['codes']
        .map<CodeSection>((e) => CodeSection.fromJson(e))
        .toList();
  }
}
