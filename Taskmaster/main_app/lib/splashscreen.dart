import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class splashscreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/main_bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: <Widget>[ 
          
            Lottie.asset(
              'animations/taski.json'
            ,height: 300,
              width: 300,
              repeat: true,
              fit:BoxFit.cover),


            Container(
              child: Image.asset('assets/light_logo.png'),
            )

          ],
        ),
      ),
    );
  }
}
