import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:main_app/services/database.dart';

class TodayTaskDialog extends StatefulWidget{
  @override
  State<TodayTaskDialog> createState() => _todayTaskState();
}

class _todayTaskState extends State<TodayTaskDialog> {
    var _selectOption;
    String _selectedPeriod = 'AM';
    DatabaseMethods db = DatabaseMethods();

    TextEditingController _hourController = TextEditingController();
    TextEditingController _minController = TextEditingController();
    TextEditingController _taskController = TextEditingController();

    void _showData(){
      Map <String,dynamic> taskInfo = {
        'task':_taskController.text.trim(),
        'hour':_hourController.text.trim(),
        'min' :_minController.text.trim(),
        'ampm':_selectedPeriod,
      };

      db.uploadTask(taskInfo,'TodayTasks');
      _hourController.clear();
      _minController.clear();
      Navigator.pop(context);
    }
    @override
    Widget build(BuildContext context) {
      return Container(
        // height: 400,
        child: Center(
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25)),
                  color: Theme
                      .of(context)
                      .cardColor,
                ),
                padding: EdgeInsets.symmetric(vertical: 10),
                width: double.infinity,
                child: Center(
                    child: Text(
                      "Add Task ",
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    )),
              ),
              Flexible(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 30),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        child: TextField(
                          controller: _taskController,
                          decoration: InputDecoration(
                              hintText: "Enter New Tasks",
                              border: OutlineInputBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                              prefixIcon: Icon(Icons.task)),
                        ),
                      ),

                      Container(
                        decoration: BoxDecoration(
                          // color: Colors.blue
                        ),
                        child: Column(
                          children: [
                            Container(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Select a time ",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 70,
                                  child: TextField(
                                    controller: _hourController,
                                    keyboardType: TextInputType.datetime,
                                    textAlign: TextAlign.center,
                                    decoration: InputDecoration(
                                        hintText: "HH",
                                        border: OutlineInputBorder()),
                                  ),
                                ),

                                Container(
                                  width: 70,
                                  child: TextField(
                                    controller: _minController,
                                    keyboardType: TextInputType.datetime,
                                    textAlign: TextAlign.center,
                                    decoration: InputDecoration(
                                        hintText: "MM",
                                        border: OutlineInputBorder()),
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topCenter,
                                  child: Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                          border: Border.all(
                                              color: Colors.black54)
                                      ),
                                      padding: EdgeInsets.symmetric(
                                          vertical: 5, horizontal: 5),
                                      width: 70,
                                      child: DropdownButton<String>(
                                        value: _selectedPeriod,
                                        onChanged: (String? newValue) {
                                          setState(() {
                                            _selectedPeriod = newValue!;
                                          });
                                        },
                                        items: <String>['AM', 'PM']
                                            .map<DropdownMenuItem<String>>(
                                                (String value) {
                                              return DropdownMenuItem<String>(
                                                value: value,
                                                child: Text(value),
                                              );
                                            }).toList(),
                                      )),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all(Theme
                                  .of(context)
                                  .cardColor)
                          ),
                          onPressed: _showData,
                          child: Text(
                            "add task",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
}
    }

