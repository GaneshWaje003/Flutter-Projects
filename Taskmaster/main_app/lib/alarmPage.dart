import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AlarmPage extends StatefulWidget{

  final String taskTitle;

  const AlarmPage({Key? key , required this.taskTitle}):super(key:key);

  @override
  _AlarmPage createState() => _AlarmPage();
}

class _AlarmPage extends State<AlarmPage>{
  @override
  Widget build(BuildContext context) {

      return Scaffold(
        backgroundColor:Theme.of(context).cardColor,
        body: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
          ),
          child: Column(  
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
                Text(widget.taskTitle ,style: TextStyle(color:Colors.white , fontSize: 32),),

                SizedBox(
                  height: 100,
                ),

                Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle
                    ),
                    child: IconButton(
                    onPressed: (){},
                    icon: Icon(Icons.check))),

              Container(
                    margin: EdgeInsets.symmetric(vertical: 50),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle
                    ),
                    child: IconButton(
                    onPressed: (){},
                    icon: Icon(Icons.task))),

              Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle
                    ),
                    child: IconButton(
                    onPressed: (){
                      Navigator.of(context).pop();
                    },
                    icon: Icon(Icons.close))),
            ],
          ),
        ),

      );

  }

}