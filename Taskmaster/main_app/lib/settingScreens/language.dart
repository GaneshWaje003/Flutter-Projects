import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Language extends StatefulWidget{
  @override
  State<Language> createState() => _LanguageState();

}

class _LanguageState extends State<Language>{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
   return Scaffold(
      appBar: AppBar(
        title: Text("Language"),
      ),
   );
  }

}