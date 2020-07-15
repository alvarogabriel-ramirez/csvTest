import 'package:csv_test/src/pages/basicoPage.dart';
import 'package:csv_test/src/pages/file.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.transparent,
    ));
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Material App',
      initialRoute: 'file',
      routes: {
        'basico': (BuildContext context) => BasicoPage(),
        'file': (BuildContext context) => FilePickerDemo()
      },
    );
  }
}
