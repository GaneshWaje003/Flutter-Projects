import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:main_app/TaskInfo.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  State<TaskPage> createState() => _taskPage();
}

// ignore: camel_case_types
class _taskPage extends State<TaskPage> {

  // for flutter notification
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  var showContainer = false;
  bool light1 = true;

  // variables for progress bar
  var totalTasks;
  var totalTasksDone = 0;
  var _percentage = 0.0;

  Map<String, bool> _checkboxStates = {};
  FirebaseFirestore db = FirebaseFirestore.instance;
  List<QueryDocumentSnapshot> _tasks = [];
  List<String> _SelectedTasks = [];

  var _selectedTaskId;

  @override
  void initState() {
    super.initState();

    // setting alarms variable
    final AndroidInitializationSettings androidInitializationSettings = AndroidInitializationSettings('app_icon');
    final InitializationSettings initializationSettings  = InitializationSettings(android: androidInitializationSettings);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // Subscribe to the stream returned by _fetchData() and update the _tasks list
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

  void _initializeSwitchStates() async {
    QuerySnapshot snapshot = await db.collection('Tasks').get();
  }

  // changing the swithches on and off
  void toggleSwitch(String taskId, bool value) {
    setState(() {
      if (taskId != -1) {
        int taskIndex = _tasks.indexWhere((task) => task.id == taskId);
        (_tasks[taskIndex].data() as Map<String, dynamic>)['completed'] = value;
        db
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

  Stream<QuerySnapshot> _fetchData() {
    return db.collection('Tasks').snapshots();
  }

  //
  // void sheduleAlarm() async{
  //   await flutterLocalNotificationsPlugin.zonedSchedule(
  //     0,
  //     'Alarm',
  //     'It\'s time!',
  //     tz.TZDateTime.from(alarmTime, tz.local),
  //     const NotificationDetails(
  //       android: AndroidNotificationDetails(
  //         'your_channel_id',
  //         'your_channel_name',
  //         importance: Importance.max,
  //         priority: Priority.high,
  //       ),
  //     ),
  //     androidAllowWhileIdle: true,
  //     matchDateTimeComponents: DateTimeComponents.time,
  //   );
  // }

  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 40),
              margin: const EdgeInsets.only(bottom: 20),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Completed Task",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 30)),
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
                      ),
                    ],
                  )
                ],
              ),
            ),
            Flexible(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: StreamBuilder<QuerySnapshot>(
                  stream: _fetchData(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
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
                        final boolState = task['completed'] is bool ? task['completed'] : (task['completed'] == 'true');
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
                                showContainer = !showContainer; // Only toggle the visibility
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
                                            completed: boolState
                                          )));
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
    final boolState = widget.task['completed'] is bool ? widget.task['completed'] as bool : widget.task['completed'] == 'true';


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
                  color: listColor,
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
                              return const Icon(Icons.check);
                            }
                            return const Icon(Icons.close);
                          },
                        ),
                        onChanged: (bool value) {
                          widget.onToggleSwitch(taskId, value);
                        },
                      ),

                      PopupMenuButton<String>(
                        color: popUpColor,
                          padding: EdgeInsets.all(0),
                          icon:Icon(Icons.more_vert),
                          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                              const PopupMenuItem(child: Text('select')),
                              const PopupMenuItem(child: Text('delete')),
                              const PopupMenuItem(child: Text('update')),
                          ],
                      ),

                    ],
                  ),
                ),
                onLongPress: ()=> setState(() {
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
