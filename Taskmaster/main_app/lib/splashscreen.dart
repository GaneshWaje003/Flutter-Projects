import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:main_app/Login.dart';
import 'package:main_app/main.dart';
import 'package:main_app/mainPage.dart';

class splashscreen extends StatefulWidget {
  @override
  State<splashscreen> createState() => _splashscreenState();
}

class _splashscreenState extends State<splashscreen> {

  var _width = 300.0;
  var _height = 300.0;

  void _animateWidth() {
    setState(() {
      _width = 0.0;
      Future.delayed(Duration(seconds: 3), () {
        _toMainPage();
      });
    });
  }

  void _toMainPage(){
        Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) =>Mainpage() ));
  }

  @override
  void initState() {
    super.initState();
    // Delaying animation start by 1 second for demonstration
    Future.delayed(Duration(seconds: 1), () {
      _animateWidth();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            // Add decoration if needed
          ),
          child: Column(

            mainAxisAlignment: MainAxisAlignment.center,

            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 200),
              ),
              Lottie.asset(
                'animations/taski.json',
                height: 300.0,
                width: 300.0,
                repeat: true,
                fit: BoxFit.cover,
              ),

              AnimatedContainer(
                duration: Duration(seconds: 4),
                width: _width,
                height: _height,
                child: Image.asset(
                  'assets/light_logo.png',
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: splashscreen(),
  ));
}
