import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CalenderDialog extends StatefulWidget {
  @override
  State<CalenderDialog> createState() => _CalenderDialogState();
}

class _CalenderDialogState extends State<CalenderDialog> {

  void _onDateTaskButtonClicked(){
        Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      decoration:
          BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(20))),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              color: Theme.of(context).cardColor,
            ),
            child: Center(
                child: Text(
              "Calender log",
              style: TextStyle(color: Colors.white, fontSize: 20),
            )),
          ),

          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextField(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10))
                      ),
                      prefixIcon: Icon(Icons.today_rounded,),
                      hintText: "Enter task for day"
                    ),
                  ),
            
                  Container(
                    alignment: Alignment.bottomRight,
                    margin: EdgeInsets.only(top: 40),
                    child: ElevatedButton(
                        style:ButtonStyle(
                          padding: WidgetStateProperty.all(EdgeInsets.symmetric(vertical: 15 , horizontal: 30)),
                          backgroundColor: WidgetStateProperty.all(Theme.of(context).cardColor),
                          shape:WidgetStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(30))
                            )
                          )
                        ) ,
                        onPressed: _onDateTaskButtonClicked,
                        child: Text("Add Task" ,style: TextStyle(color: Colors.white),)
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
