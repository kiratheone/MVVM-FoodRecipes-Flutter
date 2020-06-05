import 'package:flutter/material.dart';

import 'config.dart';
import 'home.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Config.appColor,
      ),
      home: MyHomePage(title: 'List Foods'),
    );
  }
}

enum Food { meal, dessert, favorite, others }
