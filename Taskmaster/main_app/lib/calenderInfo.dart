import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:main_app/screensBottomNavbar/calender.dart';
import 'package:main_app/services/database.dart';

class CalenderInfo extends StatefulWidget{
  final String taskId;
  final String task;
  final String dateTime;

  CalenderInfo({Key? key, required this.taskId, required this.task,required this.dateTime}):super(key: key);

  @override
  State<CalenderInfo> createState()=> _CalenderInfo();
}

class _CalenderInfo extends State<CalenderInfo> {

  DatabaseMethods db = DatabaseMethods();

  void undoText(){
    // if(_historyString.isNotEmpty){
    //
    //   setState(() {
    //     _titleController.text = _historyString.removeLast();
    //     print(_historyString);
    //   });
    // }
  }

  void redoText(){
    // if(_redoString.isNotEmpty){
    //   setState(() {
    //     _historyString.add(_redoString.removeLast());
    //     _titleController.text=_historyString.last;
    //   });
    // }
  }

  void updateInfo(ids){}

  void onTaskDeleted(taskId){
    print("Task succesfully deleted from calender"+ taskId);
    Navigator.pop(context);
  }


  @override
  Widget build(BuildContext context) {

    TextStyle whiteStyle = TextStyle(color: Colors.white);
    TextStyle darkStyle = TextStyle(color: Theme.of(context).cardColor);
    TextEditingController _taskTitleController = TextEditingController(text:widget.task);

    void _showDialog(BuildContext context) async{
      bool? result  = await showDialog(
          context: context,
          builder: (BuildContext context){
            return AlertDialog(
              backgroundColor: Theme.of(context).cardColor,
              title: Text('Cofirm Action',style: whiteStyle),
              content:Text('You want to delete Task permanantly',style: whiteStyle),
              actions: [
                TextButton(
                  child: Text('No',style: whiteStyle),
                  onPressed: () {
                    Navigator.of(context).pop(false); // Return false
                  },
                ),
                ElevatedButton(
                  child: Text('Yes',style: darkStyle),
                  onPressed: () {
                    Navigator.of(context).pop(true); // Return true
                  },
                ),
              ],
            );
          });

      if(result == true){
        bool isDeleted = await db.delCalTask(widget.taskId, onTaskDeleted);
      }

    }


    return Scaffold(
      appBar: AppBar(
        title: Text('Calender Tasks',style: TextStyle(color: Colors.white),),
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).cardColor,
        iconTheme: IconThemeData(color: Colors.grey),
        actions: [
          IconButton(
            onPressed: ()=>_showDialog(context),
            icon: const Icon(Icons.delete_rounded),
          ),
          IconButton(
            icon: const Icon(Icons.redo_rounded),
            onPressed: ()=>redoText(),
          ),
          IconButton(
            icon: const Icon(Icons.undo_rounded),
            onPressed: ()=>undoText(),
          ),
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () => updateInfo(widget.task),
          )
        ],
      ),
      body: Container(

        padding: EdgeInsets.symmetric(vertical: 20,horizontal: 20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Container(
              child: TextFormField(
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(5),
                  labelText: "task todo",
                  labelStyle: TextStyle(color: Theme.of(context).cardColor),
                  border: InputBorder.none,
                ),
                controller:_taskTitleController,
                autofocus: true,
              ),
            ),

            SizedBox(height: 30,
              child: Container(
                margin:EdgeInsets.only(top:5,bottom: 20),
                decoration: BoxDecoration(
                  border:Border(top: BorderSide(color: Colors.black))
                ),
              ),
            ),

            Container(
              child: Text('${widget.dateTime}       32 chars only'),
            ),

          ],
        )
      ),
    );
  }

}