import 'dart:ui';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:main_app/Login.dart';
import 'package:main_app/TaskInfo.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class TaskPage extends StatefulWidget {
  @override
  State<TaskPage> createState() => _taskPage();
}

class _taskPage extends State<TaskPage> {
  bool light1 = true;

  Map<String, bool> _switchStates = {};

  FirebaseFirestore db = FirebaseFirestore.instance;
  Color blueDark = Color(0xFFFFFFF);
  List<QueryDocumentSnapshot> _tasks =
      []; // Declare the _tasks list to store the task documents
  double _percentage = 0.2;
  var _selectedTaskId;

  void _initializeSwitchStates() async {
    QuerySnapshot snapshot = await db.collection('Tasks').get();
    setState(() {
      _switchStates = {
        for (var doc in snapshot.docs) doc.id: doc['completed'] ?? false
      };
    });
  }

  @override
  void initState() {
    super.initState();
    // Subscribe to the stream returned by _fetchData() and update the _tasks list
    _fetchData().listen((snapshot) {
      setState(() {
        _tasks = snapshot.docs;
        _switchStates = {
          for (var doc in snapshot.docs) doc.id: _switchStates[doc.id] ?? false
        };
      });
    });
  }

  void _toggleSwitch(String taskId, bool value) {
    setState(() {
      _switchStates[taskId] = value;
    });
    // Optionally update Firestore with the new switch state
    db.collection('Tasks').doc(taskId).update({'completed': value});
  }

  Stream<QuerySnapshot> _fetchData() {
    return db.collection('Tasks').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 40),
                margin: EdgeInsets.only(bottom: 20),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Theme.of(context).cardColor,
                ),
                child: Column(
                  children: [
                    Container(
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
                                    Text("Completed Task",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 30)),
                                    Container(
                                        margin: EdgeInsets.only(left: 3),
                                        child: Text("Keep it up 😊",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15)))
                                  ],
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(left: 30),
                                child: CircularPercentIndicator(
                                  radius: 40,
                                  lineWidth: 8,
                                  percent: _percentage,
                                  circularStrokeCap: CircularStrokeCap.round,
                                  progressColor: Colors.lightBlue,
                                  backgroundColor: Colors.white,
                                  center: Center(
                                    child: Container(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text("10",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18)),
                                          Text('/',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18)),
                                          Text("8",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              Flexible(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: StreamBuilder<QuerySnapshot>(
                    stream: _fetchData(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      }

                      if (!snapshot.hasData) {
                        return Center(child: Text("No Data Found"));
                      }

                      // Update the _tasks list with the latest data from the snapshot
                      _tasks = snapshot.data!.docs;

                      return ListView.builder(
                        itemCount: _tasks.length,
                        itemBuilder: (context, index) {
                          var task = _tasks[index].data() as Map<String, dynamic>;
                          var taskTitle = task['task'] ?? 'No title';
                          var taskId = snapshot.data!.docs[index].id;
                          var hour = task['hour'] ?? '';
                          var min = task['min'] ?? '';
                          var ampm = task['ampm'] ?? '';
                          var time = '$hour:$min $ampm';
                          var isDone = task['completed'];
                          var description = task['description'] ?? '';
                          return Container(
                            margin: EdgeInsets.only(bottom: 15),
                            decoration: BoxDecoration(
                                color: Color(0xFFEEEEFD),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15))),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Taskinfo(
                                            title: taskTitle,
                                            des: description,
                                            time: time)));
                              },
                              child: Container(
                                margin: EdgeInsets.only(left: 30),
                                child: ListTile(
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 0),
                                  title: Text(
                                    task['task'] ?? 'null',
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  subtitle: Text(task['description'] != null
                                      ? task['description']
                                      : '-'),
                                  trailing: Container(
                                    margin: EdgeInsets.only(right: 20),
                                    child: Switch(
                                      activeTrackColor: Colors.green,
                                      value: isDone ?? false,
                                      thumbIcon: WidgetStateProperty
                                          .resolveWith<Icon?>(
                                        (Set<WidgetState> states) {
                                          if (states
                                              .contains(WidgetState.selected)) {
                                            return Icon(Icons.check);
                                          }
                                          return Icon(Icons.close);
                                        },
                                      ),
                                      onChanged: (bool value) {
                                        _toggleSwitch(taskId, value);
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
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
