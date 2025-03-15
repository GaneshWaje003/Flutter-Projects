import 'package:flutter/cupertino.dart';

class ListModel{
  Text title;
  Icon leading;
  Function(String) callback;

  ListModel({required this.title , required this.leading , required this.callback});

}