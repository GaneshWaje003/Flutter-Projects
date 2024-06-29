import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CalenderPage extends StatefulWidget{
  @override
  State<CalenderPage> createState() => _calenderPage();
}

class _calenderPage extends State<CalenderPage>{
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body:Container(
        child: Text("calender"),
      ),
    );

  }

}