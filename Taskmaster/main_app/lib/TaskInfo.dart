import 'package:flutter/material.dart';

class Taskinfo extends StatefulWidget {
  final String title;
  final String des;

  Taskinfo({Key? key, required this.title, required this.des})
      : super(key: key);

  @override
  State<Taskinfo> createState() => _TaskInfoState();
}

class _TaskInfoState extends State<Taskinfo> {
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.title);
    _descriptionController = TextEditingController(text: widget.des);
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
        actions: [
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
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Column(
              children: [
                Container(
                  child: TextField(
                    style: TextStyle(
                      fontSize: 30.0,
                    ),
                    controller: _titleController,
                    decoration: InputDecoration(
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
                      controller: _descriptionController,
                      style: TextStyle(
                        fontSize: 16.0,
                      ),
                      decoration: InputDecoration(
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
