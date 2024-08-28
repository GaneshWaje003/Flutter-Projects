import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class About extends StatefulWidget {
  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {
  TextStyle Headingstyle = TextStyle(fontSize: 24, fontWeight: FontWeight.bold);
  TextStyle Normalstyle = TextStyle(
    fontSize: 18,
    letterSpacing: 1.5, // Space between letters
    height: 1.5, // Line height
    fontWeight: FontWeight.bold,
  );

  var info =
      '    TaskMaster is a comprehensive task management application developed using Flutter and Dart, designed to help users stay organized and efficiently manage their daily tasks. This app is available for both Android and iOS platforms, adhering to the respective design guidelines for each operating system';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).cardColor,
        title: Text(
          "about",
          style: TextStyle(color: Colors.white),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          children: [
            Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Text("Taskmaster", style: Headingstyle)),
            Container(
              child: Container(
                child: Text(
                  info,
                  textAlign: TextAlign.justify,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
