import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddUser extends StatefulWidget{
  @override
  State<AddUser> createState()=>AddUserState();
}

class AddUserState extends State<AddUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Center(child: Text("add User"),)
    );
  }

}