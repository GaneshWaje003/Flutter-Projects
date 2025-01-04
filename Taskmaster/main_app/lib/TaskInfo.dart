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
  List<String> _redoString = [];
  List<String> _historyString = [];
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

    db.updateData(widget.id,'Tasks' ,taskData);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    void undoText() {
      if (_historyString.isNotEmpty) {
        setState(() {
          _titleController.text = _historyString.removeLast();
          print(_historyString);
        });
      }
    }

    void redoText() {
      if (_redoString.isNotEmpty) {
        setState(() {
          _historyString.add(_redoString.removeLast());
          _titleController.text = _historyString.last;
        });
      }
    }

    void onTaskDeleted(taskId) {
      print('Task with id $taskId is deleted permantly');

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const TaskPage()));
    }

    TextStyle whiteStyle = TextStyle(color: Colors.white);
    TextStyle darkStyle = TextStyle(color: Theme.of(context).cardColor);

    void _showDialog(BuildContext context) async {
      bool? result = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              backgroundColor: Theme.of(context).cardColor,
              title: Text('Cofirm Action', style: whiteStyle),
              content: Text('You want to delete Task permanantly',
                  style: whiteStyle),
              actions: [
                TextButton(
                  child: Text('No', style: whiteStyle),
                  onPressed: () {
                    Navigator.of(context).pop(false); // Return false
                  },
                ),
                ElevatedButton(
                  child: Text('Yes', style: darkStyle),
                  onPressed: () {
                    Navigator.of(context).pop(true); // Return true
                  },
                ),
              ],
            );
          });

      if (result == true) {
        bool isDeleted = await db.delTask(taskId, 'Tasks', onTaskDeleted);
      }
    }

    return Scaffold(
      appBar: AppBar(
        elevation: 1.0,
        backgroundColor: Theme.of(context).cardColor,
        iconTheme: IconThemeData(color: Colors.white70),
        actions: [
          IconButton(
            onPressed: () => _showDialog(context),
            icon: const Icon(Icons.delete_rounded),
          ),
          IconButton(
            icon: const Icon(Icons.redo_rounded),
            onPressed: () => redoText(),
          ),
          IconButton(
            icon: const Icon(Icons.undo_rounded),
            onPressed: () => undoText(),
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
                TextFormField(
                  autofocus: true,
                  maxLength: 32,
                  cursorColor: Colors.black,

                  style: const TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold
                  ),

                  controller: _titleController,

                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.zero,
                    hintText: 'title',
                    border: InputBorder.none,
                    counterText: '',
                  ),
                  onChanged: (value) {
                    _historyString.add(value);
                    _redoString.add(value);
                    print(_historyString);
                  },
                ),

                TextFormField(
                  enabled: false,
                  cursorColor: Colors.grey,
                  controller: _timeController,
                  style: const TextStyle(fontSize: 12.0, color: Colors.grey),
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.zero,
                    border: InputBorder.none,
                  ),
                ),

                TextFormField(
                  controller: _descriptionController,
                  style: const TextStyle(
                    fontSize: 16.0,
                  ),
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.zero,
                    border: InputBorder.none,
                    hintText: 'description'
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
