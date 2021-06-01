import 'package:flutter/material.dart';
import 'package:notes/screens/homescreen.dart';

void main()=> runApp(MyApp());


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
    home: Homescreen(),
  );
}

