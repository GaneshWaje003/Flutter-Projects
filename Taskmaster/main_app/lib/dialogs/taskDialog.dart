import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:main_app/services/database.dart';

class Taskdialog extends StatefulWidget {
  @override
  State<Taskdialog> createState() => _stateTaskDialogg();
}

class _stateTaskDialogg extends State<Taskdialog> {
  String _selectedPeriod = 'AM';
  DatabaseMethods db = DatabaseMethods();
  final _formKey = GlobalKey<FormState>();

  TextEditingController _hourController = TextEditingController();
  TextEditingController _minController = TextEditingController();
  TextEditingController _taskController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  String? _taskErrorMessage; // Error message for task

  Future<void> _showData() async {
    String title = _taskController.text.trim();

    // Check for duplication
    bool isDuplicate = await db.checkDuplication('Tasks', 'task', title);
    if (isDuplicate) {
      setState(() {
        _taskErrorMessage = 'Task already exists';
      });
      return; // Exit the function to prevent adding the task
    } else {
      setState(() {
        _taskErrorMessage = null; // Clear the error message if not a duplicate
      });
    }

    // Validate the form fields
    if (_formKey.currentState?.validate() ?? false) {
      Map<String, dynamic> taskInfo = {
        'task': _taskController.text.trim(),
        'description': _descriptionController.text.trim(),
        'hour': _hourController.text.trim(),
        'min': _minController.text.trim(),
        'ampm': _selectedPeriod,
        'completed': false,
      };

      // Add the data to Firebase
      await db.addTask(taskInfo);

      // Clear the controllers
      _hourController.clear();
      _minController.clear();
      _taskController.clear();
      _descriptionController.clear();

      // Close the bottom sheet
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(25), topRight: Radius.circular(25)),
              color: Theme.of(context).cardColor,
            ),
            padding: const EdgeInsets.symmetric(vertical: 10),
            width: double.infinity,
            child: const Center(
                child: Text(
                  "Add Task",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                )),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    child: TextFormField(
                      controller: _taskController,
                      decoration: InputDecoration(
                        hintText: "Enter New Task",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10))),
                        prefixIcon: Icon(Icons.task),
                        errorText: _taskErrorMessage,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter a value';
                        }
                        return null;
                      },
                    ),
                  ),
                  Container(
                    height: 100,
                    margin: const EdgeInsets.only(top: 10),
                    child: Expanded(
                      child: Form(
                        key: _formKey,
                        child: TextFormField(
                          expands: true,
                          minLines: null,
                          maxLines: null,
                          controller: _descriptionController,
                          decoration: const InputDecoration(
                            hintText: "Enter Task Description",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10)),
                            ),
                            prefixIcon: Icon(Icons.description),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter a value';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: const BoxDecoration(
                      // color: Colors.blue
                    ),
                    child: Column(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              "Select a time",
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
                              decoration: const BoxDecoration(
                                borderRadius:
                                BorderRadius.all(Radius.circular(20)),
                              ),
                              child: TextFormField(
                                controller: _hourController,
                                keyboardType: TextInputType.datetime,
                                textAlign: TextAlign.center,
                                decoration: const InputDecoration(
                                    hintText: "HH",
                                    border: OutlineInputBorder()
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a value';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            Container(
                              width: 70,
                              decoration: const BoxDecoration(
                                borderRadius:
                                BorderRadius.all(Radius.circular(20)),
                              ),
                              child: TextField(
                                controller: _minController,
                                keyboardType: TextInputType.datetime,
                                textAlign: TextAlign.center,
                                decoration: const InputDecoration(
                                    hintText: "MM",
                                    border: OutlineInputBorder()),
                              ),
                            ),
                            Align(
                              alignment: Alignment.topCenter,
                              child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                      border:
                                      Border.all(color: Colors.black54)),
                                  padding: const EdgeInsets.symmetric(
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
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.symmetric(
                                  vertical: 13, horizontal: 30)),
                          backgroundColor: MaterialStateProperty.all(
                              Theme.of(context).cardColor)),
                      onPressed: _showData,
                      child: const Text(
                        "Add Task",
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
    );
  }
}
