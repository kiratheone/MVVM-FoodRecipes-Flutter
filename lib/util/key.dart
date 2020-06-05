

import 'package:flutter/cupertino.dart';

class SubsKeys {
  // Home Screens
  static final title = const Key('__title__');
  static final navbarFavorite = const Key('__navbar_favorite__');
  static final navbarSeafood = const Key('__navbar_seafood__');
  static final navbarDessert = const Key('__navbar_dessert__');
  static final loading = const Key('__loading__');

  static Key detail(String id) => Key('__snackbar_action_${id}__');
}
