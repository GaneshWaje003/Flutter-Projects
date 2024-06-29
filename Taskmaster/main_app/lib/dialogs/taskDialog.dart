import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Taskdialog extends StatefulWidget {
  @override
  State<Taskdialog> createState() => _stateTaskDialogg();
}

class _stateTaskDialogg extends State<Taskdialog> {
  TimeOfDay selectedTime = TimeOfDay.now();

  List<String> _hours = [
    '12', '1','2','3','4','5','6','7','8','9','10','11','12',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      child: Center(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25)),
                color: Theme.of(context).primaryColor,
              ),
              padding: EdgeInsets.symmetric(vertical: 10),
              width: double.infinity,
              // margin: EdgeInsets.symmetric(vertical: 10),
              child: Center(
                  child: Text(
                "Add Task ",
                style: TextStyle(color: Colors.white, fontSize: 20),
              )),
            ),

            Container(
                margin: EdgeInsets.symmetric(horizontal: 30),
                child: Column(
                  
                  children: [
                    Container(
                      child: TextField(
                        decoration: InputDecoration(
                            hintText: "Enter New Tasks",
                            border: OutlineInputBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            prefixIcon: Icon(Icons.task)),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all(
                                Theme.of(context).primaryColor)),
                        onPressed: (){

                        },
                        child: Text(
                          "add task",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),



                  ],
                ),
              ),
          ],
            ),
      ),
    );
  }
}
