import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:main_app/screensBottomNavbar/tasks.dart';
import 'package:main_app/services/database.dart';

class Taskinfo extends StatefulWidget {
  final String title;
  final String des;
  final String time;

  Taskinfo({Key? key, required this.title, required this.des , required this.time})
      : super(key: key);

  @override
  State<Taskinfo> createState() => _TaskInfoState();
}

class _TaskInfoState extends State<Taskinfo> {

  FirebaseFirestore ab = FirebaseFirestore.instance;


  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _timeController;
  DatabaseMethods dbFile = DatabaseMethods();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.title);
    _descriptionController = TextEditingController(text: widget.des);
    _timeController = TextEditingController(text: widget.time);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1.0,
        actions: [

          IconButton(onPressed: () async{
            var isDelted = dbFile.delTaskWithTitle(widget.title );
            Navigator.push(context, MaterialPageRoute(builder: (context)=>TaskPage()));

          }, icon:Icon(Icons.delete_rounded)),

          IconButton(
            icon: Icon(Icons.redo_rounded),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.undo_rounded),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {},
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Column(
              children: [
                Container(
                  child: TextFormField(
                    autofocus: true,
                    style: TextStyle(
                      fontSize: 30.0,
                    ),
                    controller: _titleController,
                    decoration: InputDecoration(
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
                    ),
                  ),
                ),
                Container(
                  child: Container(
                    child: TextFormField(
                      controller: _timeController,
                      style: TextStyle(
                        fontSize: 12.0,
                        color: Colors.orange
                      ),
                      decoration: InputDecoration(

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
                  child: Container(
                    child: TextFormField(
                      controller: _descriptionController ,
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                      decoration: InputDecoration(
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
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
