import 'package:flutter/material.dart';
import 'package:notes/screens/homescreen.dart';
import 'package:notes/screens/splashscreen.dart';
import 'package:showcaseview/showcaseview.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  static final String title = 'Notes';

  @override
  Widget build(BuildContext context) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.black,
          scaffoldBackgroundColor: Colors.blueGrey.shade900,
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
        ),
        home: Splashscreen(),
        routes: {
          'homescreen': (context) => ShowCaseWidget(
              autoPlay: true,
              autoPlayLockEnable: true,
              autoPlayDelay: Duration(seconds: 3),
              builder: Builder(
                builder: (_) => Homescreen(),
              )),
        },
      );
}
