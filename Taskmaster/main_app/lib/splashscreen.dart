import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:main_app/Login.dart';
import 'package:main_app/mainPage.dart';
import 'package:main_app/services/database.dart';

class splashscreen extends StatefulWidget {
  @override
  State<splashscreen> createState() => _splashscreenState();
}

class _splashscreenState extends State<splashscreen> {

  DatabaseMethods db = DatabaseMethods();

  void _toPage(BuildContext context, Widget page) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => page));
  }

  void checkUserPresent() async {
    var isUserPresent = await db.isUserPresent();
    Future.delayed(Duration(seconds: 4), () {
      if (isUserPresent) {
        _toPage(context, Mainpage());
      } else {
        _toPage(context, Login());
      }
    });
  }

  @override
  void initState() {
    super.initState();
    checkUserPresent();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
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


              SizedBox(height: 100,),

              Container(
                alignment: Alignment.center,
                // width: _width,
                // height: _height,
                child:Text('TaskMaster',style: TextStyle(fontSize:28,fontWeight:FontWeight.bold,letterSpacing: 1,height: 0),)

                /*Image.asset(
                  'assets/tm_logo.jpg',
                  fit: BoxFit.contain,
                ),*/
              ),
              Container(child: Text('A Smart ToDo App',style: TextStyle(fontSize: 12,height: 0)),)
            ],
          ),
        ),
      ),
    );
  }
}
