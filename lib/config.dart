
import 'package:flutter/material.dart';

enum Flavor {
  ENAK,
  LEZAT,
}

class Config {
  static Flavor appFlavor;

  static String get appString {
    switch (appFlavor) {
      case Flavor.ENAK:
        return 'ENAK';
        break;
      case Flavor.LEZAT:
        return 'LEZAT';
        break;
      default:
        return 'MAIN';
        break;
    }
  }

  static Color get appColor {
    switch (appFlavor) {
      case Flavor.ENAK:
        return Colors.blue;
        break;
      case Flavor.LEZAT:
        return Colors.red;
        break;
      default:
        return Colors.blue;
        break;
    }
  }
}