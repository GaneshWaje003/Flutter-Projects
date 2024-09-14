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

    TextEditingController _taskController = TextEditingController();
    TextEditingController _descriptionController = TextEditingController();

    void _addNotes(){
      Map <String,dynamic> taskInfo = {
        'task':_taskController.text.trim(),
        'description':_descriptionController.text.trim()
      };

      db.uploadTask(taskInfo,'Notes');
      _descriptionController.clear();
      _taskController.clear();
      Navigator.pop(context);
    }
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text('add note'),
          elevation: 1,
          automaticallyImplyLeading: true,
          actions: [
            IconButton(onPressed: ()=>_addNotes(), icon: Icon(Icons.check))
          ],
        ),
        body: SafeArea(
          child: Container(
                  padding: EdgeInsets.symmetric(vertical: 20,horizontal: 20),
            // height: 400,
            child: Column(
              children: [
                Container(
                // color: Colors.grey,
                  padding: EdgeInsets.only(top: 10 , bottom: 3),
                  child: TextField(
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                    autofocus: true,
                    maxLength: 32,
                    controller: _taskController,
                    decoration: InputDecoration(
                    counterText: '',
                      border: InputBorder.none,
                        hintText: "title",
                        // prefixIcon: Icon(Icons.task)
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  child: Text('32 chars only title',style: TextStyle(color: Colors.grey),),
                ),
                Expanded(
                // color: Colors.grey,
                //   padding: EdgeInsets.symmetric(vertical: 10),
                  child: TextField(
                    expands: true,
                    maxLines: null,
                    minLines: null,
                    style: TextStyle(
                      fontSize: 16
                    ),
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                        hintText: "description",
                        // prefixIcon: Icon(Icons.task)
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
    }

