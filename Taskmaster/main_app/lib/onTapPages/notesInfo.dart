import 'package:flutter/material.dart';
import 'package:main_app/services/database.dart';

class NotesInfo extends StatefulWidget {
  @override
  State<NotesInfo> createState() => NotesInfoState();
  final String taskId;
  final String title;
  final String desc;
  final String cDate;

  NotesInfo(
      {required this.taskId,
      required this.title,
      required this.desc,
      required this.cDate});
}

class NotesInfoState extends State<NotesInfo> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _dateController;
  late DateTime cTime;
  late DatabaseMethods db;
  late List<String> undoList;
  late List<String> redoList;
  String currText = '';
  void redoText() {
    if(redoList.isNotEmpty){
      setState(() {
      currText = redoList.removeLast();
      undoList.add(currText);
      _titleController.text = currText;
      });
    }

    setState(() {});
  }

  void undoText() {
    if(undoList.isNotEmpty){
      redoList.add(currText);
      currText = undoList.removeLast();
      setState(() {});
    }
    _titleController.text = undoList.last;
  }

  void updateInfo(String taskId) {
    String cDate = '${cTime.day}/${cTime.month}/${cTime.year}';
    Map<String, dynamic> taskData = {
      'task': _titleController.text.trim(),
      'description': _descriptionController.text.trim(),
      'cDate': cDate,
    };
    db.updateData(taskId, 'Notes', taskData);
    Navigator.of(context).pop();
  }

  void onTaskDeleted(String taskId) {
    Navigator.of(context).pop();
  }

  void updateTitle(value){
    undoList.add(value);
  }



  @override
  void initState() {
    super.initState();

    undoList = [];
    redoList = [];
    _titleController = TextEditingController(text: widget.title);
    _descriptionController = TextEditingController(text: widget.desc);
    cTime = DateTime.now();
    _dateController =
        TextEditingController(text: widget.cDate + ' 32 chars only');
    db = DatabaseMethods();
  }

  @override
  void dispose() {
    super.dispose();

    _titleController.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
  }

  void deleteNotes(String taskId) async {

    TextStyle whiteStyle = TextStyle(color: Colors.white);
    TextStyle darkStyle = TextStyle(color: Theme.of(context).cardColor);
      bool? result = await showDialog(
          context: context,
          builder: (BuildContext context) {
            return Container(
              child: AlertDialog(
                backgroundColor: Theme.of(context).colorScheme.primary,
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
              ),
            );
          });

      if (result == true) {
        bool isDeleted = await db.delTask(taskId, 'Notes', onTaskDeleted);
      }
    }

  @override
  Widget build(BuildContext context) {




    return Scaffold(
      appBar: AppBar(
        elevation: 1.0,
        backgroundColor: Theme.of(context).cardColor,
        iconTheme: IconThemeData(color: Colors.white70),
        actions: [
          IconButton(
            onPressed: () => deleteNotes(widget.taskId), //_showDialog(context),,
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
            onPressed: () => updateInfo(widget.taskId),
          )
        ],
      ),
      body: Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.only(top: 20),
                child: TextField(
                  controller: _titleController,
                  maxLength: 32,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
                  autofocus: true,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(0),
                    counterText: "",
                    border: InputBorder.none,
                  ),
                  onChanged: (value) => updateTitle(value),
                ),
              ),
              Container(
                  child: TextField(
                controller: _dateController,
                style: TextStyle(fontSize: 12),
                enabled: false,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.zero,
                  border: InputBorder.none,
                ),
              )),
              Flexible(
                child: TextField(
                  controller: _descriptionController,
                  maxLength: null,
                  minLines: null,
                  maxLines: null,
                  expands: true,
                  decoration: InputDecoration(
                    hintText: 'description',
                    border: InputBorder.none,
                  ),
                ),
              )
            ],
          )),
    );
  }
}
