import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Splashscreen extends StatefulWidget {
  const Splashscreen({Key? key}) : super(key: key);

  @override
  _SplashscreenState createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3),
        () => Navigator.popAndPushNamed(context, 'homescreen'));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'images/logo.png',
            height: 100.0,
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            'Notes',
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
            ),
          ),
          SizedBox(
            height: 100,
          ),
          SpinKitRotatingCircle(
            color: Colors.deepOrange,
          )
        ],
      ),
      bottomNavigationBar: Container(
          height: 50, child: Center(child: Text('by: Daniel Wanyoro'))),
    );
  }
}
