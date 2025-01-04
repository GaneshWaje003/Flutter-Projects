import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:main_app/TaskInfo.dart';
import 'package:main_app/alarmPage.dart';
import 'package:main_app/services/database.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:shimmer/shimmer.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  State<TaskPage> createState() => _taskPage();
}

class _taskPage extends State<TaskPage> {
  bool light1 = true;

  //firebase and firebase methods obljects
  FirebaseFirestore db = FirebaseFirestore.instance;
  DatabaseMethods databaseMethods = DatabaseMethods();

  // variables for progress bar
  var totalTasks;
  var totalTasksDone = 0;
  var _percentage = 0.0;

  // for the selection purpose X
  Map<String, bool> _checkboxStates = {};
  var _selectedTaskId;
  var showContainer = false;

  var showNotification = false;
  List<QueryDocumentSnapshot> _tasks = [];

  List<String> _SelectedTasks = [];

  // for shimmer
  bool _isShimmerEnabled = true; // Local variable for shimmer state

  @override
  void initState() {
    super.initState();

    _fetchData().listen((snapshot) {
      setState(() {
        _tasks = snapshot.docs;
        totalTasks = _tasks.isNotEmpty ? _tasks.length : 0;
        totalTasksDone = _tasks
            .where((task) =>
                (task.data() as Map<String, dynamic>)['completed'] == true)
            .length;
        _percentage = _tasks.isNotEmpty ? totalTasksDone / totalTasks : 0.0;
      });
    });
  }

  void showNotificationPage(String title) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => AlarmPage(taskTitle: title)));
  }

  void _initializeSwitchStates() async {
    QuerySnapshot snapshot = await db.collection('Tasks').get();
  }

  // changing the swithches on and off
  void toggleSwitch(String taskId, bool value) {
    setState(() {
      if (taskId != -1) {
        int taskIndex = _tasks.indexWhere((task) => task.id == taskId);
        (_tasks[taskIndex].data() as Map<String, dynamic>)['completed'] = value;
        databaseMethods.userCollectionRef
            .collection('Tasks')
            .doc(taskId)
            .update({'completed': value}).then((_) {
          print("value changed");
        }).catchError((e) {
          print('error come $e');
        });
      }
      _scrollController.jumpTo(_scrollController.offset);
    });
  }

  // toggling the switch
  void toggleCheckbox(var taskId, bool value) {
    setState(() {
      if (value == 'true') {
        _SelectedTasks.add(taskId);
      } else {
        _SelectedTasks.remove(taskId);
      }
    });
  }

  // DatabaseMethods databaseMethods = new DatabaseMethods();

  Stream<QuerySnapshot> _fetchData() {
    return databaseMethods.userCollectionRef.collection('Tasks').snapshots();
  }

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(140),
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("Completed Task",
                            style:
                                TextStyle(color: Colors.white, fontSize: 30)),
                        Container(
                            margin: const EdgeInsets.only(left: 3),
                            child: const Text("Keep it up 😊",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15)))
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(left: 30),
                    child: CircularPercentIndicator(
                      radius: 40,
                      restartAnimation: true,
                      lineWidth: 8,
                      percent: _percentage,
                      circularStrokeCap: CircularStrokeCap.round,
                      progressColor: Colors.lightBlue,
                      backgroundColor: Colors.white,
                      center: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('$totalTasks',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18)),
                            const Text('/',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18)),
                            Text('$totalTasksDone',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(top: 20),
        child: Column(
          children: <Widget>[
            Flexible(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: StreamBuilder<QuerySnapshot>(
                  stream: _fetchData(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Shimmer.fromColors(
                          baseColor: Colors.grey.shade300,
                          highlightColor: Colors.grey.shade100,
                          enabled: true,
                          child: ListView.builder(
                              itemCount: 10,
                              itemBuilder: (context, index) {
                                return Container(
                                  height: 20,
                                  margin: const EdgeInsets.only(bottom: 15),
                                );
                              }));
                    }

                    if (!snapshot.hasData) {
                      return const Center(child: Text("No Data Found"));
                    }

                    _tasks = snapshot.data!.docs;

                    return ListView.builder(
                      controller: _scrollController,
                      itemCount: _tasks.length,
                      itemBuilder: (context, index) {
                        final task =
                            _tasks[index].data() as Map<String, dynamic>;
                        final taskTitle = task['task'] ?? 'No title';
                        final taskId = snapshot.data!.docs[index].id;
                        final hour = task['hour'] ?? '';
                        final min = task['min'] ?? '';
                        final ampm = task['ampm'] ?? '';
                        final time = '$hour:$min $ampm';
                        final boolState = task['completed'] is bool
                            ? task['completed']
                            : (task['completed'] == 'true');
                        final description = task['description'] ?? '';
                        final isSelected = _SelectedTasks.contains(taskId);

                        return TaskItem(
                            task: task,
                            taskId: taskId,
                            isSelected: isSelected,
                            onToggleSwitch: toggleSwitch,
                            onToggleCheckbox: toggleCheckbox,
                            onLongPress: () {
                              setState(() {
                                showContainer =
                                    !showContainer; // Only toggle the visibility
                              });
                            },
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Taskinfo(
                                          id: taskId,
                                          title: taskTitle,
                                          des: description,
                                          hour: hour,
                                          min: min,
                                          ampm: ampm,
                                          completed: boolState)));
                            });
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TaskItem extends StatefulWidget {
  final Map<String, dynamic> task;
  final String taskId;
  final bool isSelected;
  final Function(String, bool) onToggleSwitch;
  final Function(String, bool) onToggleCheckbox;
  final VoidCallback onLongPress;
  final VoidCallback onTap;

  TaskItem(
      {Key? key,
      required this.task,
      required this.taskId,
      required this.isSelected,
      required this.onToggleSwitch,
      required this.onToggleCheckbox,
      required this.onLongPress,
      required this.onTap})
      : super(key: key);

  @override
  State<TaskItem> createState() => _TaskItem();
}

class _TaskItem extends State<TaskItem> {
  bool _isShimmerEnabled = true; // Local variable for shimmer state

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Color listColor = Color(0xFFEEEEFD);
    final Color popUpColor = Color(0xFFEEEDFD);
    var _isSelected = widget.isSelected;
    final taskId = widget.taskId;
    final taskTitle = widget.task['task'] ?? 'no title';
    final description = widget.task['description'] ?? 'no discription';
    final hour = widget.task['hour'] ?? '0';
    final min = widget.task['min'] ?? '0';
    final ampm = widget.task['ampm'] ?? '0';
    final boolState = widget.task['completed'] is bool
        ? widget.task['completed'] as bool
        : widget.task['completed'] == 'true';

    DatabaseMethods db = DatabaseMethods();
    TextStyle whiteStyle = TextStyle(color: Colors.white);
    TextStyle darkStyle = TextStyle(color: Theme.of(context).cardColor);

    void onTaskDeleted(taskId) {
      print('Task with id $taskId is deleted permantly');

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const TaskPage()));
    }

    void _showDialog(BuildContext context) async {
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
        bool isDeleted = await db.delTask(taskId, 'Tasks', onTaskDeleted);
      }
    }

    void _onMenuItemSelected(context, value) {
      switch (value) {
        case 'delete':
          _showDialog(context);
      }
    }

    return Container(
      key: ValueKey(taskId),
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 15),
      child: Row(
        children: [
          if (_isSelected)
            (Container(
              child: Checkbox(
                value: _isSelected,
                onChanged: (bool? value) =>
                    widget.onToggleCheckbox(taskId, value ?? false),
              ),
            )),
          Flexible(
            child: Container(
              padding: EdgeInsets.only(left: 20.0),
              decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.tertiary,
                  borderRadius: const BorderRadius.all(Radius.circular(15))),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                title: Text(
                  taskTitle ?? 'null',
                  style: const TextStyle(fontSize: 18),
                ),
                subtitle: Text(description),
                trailing: Container(
                  margin: const EdgeInsets.only(right: 5),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Switch(
                        activeTrackColor: Colors.green,
                        value: boolState,
                        thumbIcon: WidgetStateProperty.resolveWith<Icon?>(
                          (Set<WidgetState> states) {
                            if (states.contains(WidgetState.selected)) {
                              return const Icon(
                                Icons.check,
                                color: Colors.green,
                              );
                            }
                            return const Icon(Icons.close);
                          },
                        ),
                        onChanged: (bool value) {
                          widget.onToggleSwitch(taskId, value);
                        },
                      ),
                      PopupMenuButton<String>(
                        onSelected: (String value) {
                          _onMenuItemSelected(context, value);
                        },
                        color: popUpColor,
                        padding: EdgeInsets.all(0),
                        icon: Icon(Icons.more_vert),
                        itemBuilder: (BuildContext context) =>
                            <PopupMenuEntry<String>>[
                          const PopupMenuItem(
                              value: 'select', child: Text('select')),
                          const PopupMenuItem(
                              value: 'delete', child: Text('delete')),
                        ],
                      ),
                    ],
                  ),
                ),
                onLongPress: () => setState(() {
                  _isSelected = !_isSelected; // Toggle selection on long press
                }),
                onTap: widget.onTap,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
