import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class TaskPage extends StatefulWidget {
  @override
  State<TaskPage> createState() => _taskPage();
}

class _taskPage extends State<TaskPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(bottom: 30),
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 40),
            width: double.infinity,
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(20))),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      // padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      child: IconButton(
                        icon: Icon(Icons.arrow_back_ios_new_rounded,color: Theme.of(context).primaryColor,),
                        onPressed: () {},
                      ),
                    ),

                    Container(
                      child: Icon(Icons.menu_rounded,color: Colors.white,),
                    ),
                  ],
                ),

                Container(
                  margin: EdgeInsets.only(top: 50),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                          child: Row(
                            children: [
                              Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Completed Task",style:TextStyle(color:Colors.white,fontSize: 30)),
                                    Container(margin: EdgeInsets.only(left: 3),child: Text("Keep it up 😊",style:TextStyle(color:Colors.white,fontSize: 15)))
                                  ],
                                ),
                              ),

                              Container(
                                margin: EdgeInsets.only(left: 30),
                                child: CircularPercentIndicator(
                                  radius: 40,
                                  lineWidth: 8,
                                  percent: 0.8,
                                  circularStrokeCap: CircularStrokeCap.round,
                                  progressColor: Colors.green,
                                  backgroundColor: Colors.white,
                                  center:
                                  Center(
                                    child: Container(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text("10",style:TextStyle(color: Colors.white,fontSize: 18)),
                                          Text('/',style:TextStyle(color: Colors.white,fontSize: 18)),
                                          Text("8",style:TextStyle(color: Colors.white,fontSize: 18)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
