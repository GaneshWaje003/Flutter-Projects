import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:main_app/screensBottomNavbar/tasks.dart';
import 'package:main_app/services/database.dart';

class Taskinfo extends StatefulWidget {
  final String id;
  final String title;
  final String des;
  final String hour;
  final String min;
  final String ampm;
  final bool completed;

  Taskinfo(
      {Key? key,
      required this.id,
      required this.title,
      required this.des,
      required this.hour,
      required this.min,
      required this.ampm,
      required this.completed})
      : super(key: key);

  @override
  State<Taskinfo> createState() => _TaskInfoState();
}

class _TaskInfoState extends State<Taskinfo> {
  late var taskId;
  FirebaseFirestore ab = FirebaseFirestore.instance;
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _timeController;
   List<String> _redoString =[];
   List<String> _historyString =[];
  DatabaseMethods db = DatabaseMethods();

  @override
  void initState() {
    super.initState();
    taskId = widget.id;
    _titleController = TextEditingController(text: widget.title);
    _descriptionController = TextEditingController(text: widget.des);
    _timeController = TextEditingController(
      text: '${widget.hour}:${widget.min} ${widget.ampm} | 32 characters',
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  // update info
  void updateInfo(taskId) {
    Map<String, dynamic> taskData = {
      'task': _titleController.text.trim(),
      'description': _descriptionController.text.trim(),
      'hour': widget.hour ?? '0',
      'min': widget.min ?? '0',
      'ampm': widget.ampm ?? '0',
      'completed': false,
    };

    db.updateData(widget.id, taskData);
  }


  @override
  Widget build(BuildContext context) {

    void undoText(){
      if(_historyString.isNotEmpty){

      setState(() {
        _titleController.text = _historyString.removeLast();
        print(_historyString);
      });
      }
    }

    void redoText(){
      if(_redoString.isNotEmpty){
      setState(() {
        _historyString.add(_redoString.removeLast());
        _titleController.text=_historyString.last;
      });
      }
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 1.0,
        backgroundColor: Theme.of(context).cardColor,
        iconTheme: IconThemeData(
          color: Colors.white70
        ),
        actions: [
          IconButton(
            onPressed: () async {
              bool isDeleted = await db.delTaskWithTitle(widget.title);
              if (isDeleted) {
                Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context) => const TaskPage()));
              } else {
                // Optionally show an error message
                print('Failed to delete task');
              }
            },
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
            onPressed: () => updateInfo(widget.id),
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Column(
              children: [
                Container(
                  child: TextFormField(

                    autofocus: true,
                    maxLength: 32,
                    cursorColor: Colors.black,
                    style: const TextStyle(
                      fontSize: 30.0,
                    ),
                    controller: _titleController,
                    decoration: const InputDecoration(
                      contentPadding: EdgeInsets.symmetric(vertical: 0),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.transparent), // Transparent border
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors
                                .transparent), // Transparent border when enabled
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.transparent,
                            width: 2.0), // Custom border when focused
                      ),
                      counterText: '',
                    ),
                    onChanged: (value){
                      _historyString.add(value);
                      _redoString.add(value);
                      print(_historyString);
                    },
                  ),
                ),
                Container(
                  margin: EdgeInsets.all(0),
                  padding: EdgeInsets.all(0),
                  decoration: BoxDecoration(
                      border: Border(
                          bottom:
                              BorderSide(color: Theme.of(context).cardColor, width: 1.0))),
                  child: Container(
                    child: TextFormField(
                      cursorColor: Colors.grey,
                      controller: _timeController,
                      style:
                          const TextStyle(fontSize: 12.0, color: Colors.grey),
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.zero,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.transparent), // Transparent border
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors
                                  .transparent), // Transparent border when enabled
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.transparent,
                              width: 2.0), // Custom border when focused
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  child: Column(
                    children: [
                      Container(
                          margin: EdgeInsets.only(top: 10),
                          alignment: Alignment.topLeft,
                          child: Text("Description : ",style:TextStyle(fontSize: 18,fontWeight: FontWeight.bold),)
                      ),
                      Container(
                        child: TextFormField(
                          controller: _descriptionController,
                          style: const TextStyle(
                            fontSize: 16.0,
                          ),
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.zero,
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color:
                                      Colors.transparent), // Transparent border
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors
                                      .transparent), // Transparent border when enabled
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Colors.transparent,
                                  width: 2.0), // Custom border when focused
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
