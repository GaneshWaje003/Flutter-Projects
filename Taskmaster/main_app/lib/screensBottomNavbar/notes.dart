import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:main_app/onTapPages/notesInfo.dart';
import 'package:main_app/services/database.dart';

class Notes extends StatefulWidget {
  @override
  State<Notes> createState() => _TodayTaskState();
}

class _TodayTaskState extends State<Notes> {
  List<QueryDocumentSnapshot> todayTasks = [];
  DatabaseMethods firebaseMethods = DatabaseMethods();
  late FirebaseFirestore db;
  var _selectedTaskId;

  void _removeTask(String taskId) async {
    bool isDelted = await firebaseMethods.delTask(taskId, 'Notes', _removeTask);

    if (!isDelted) {
      print("data not delted");
    }
  }

  Stream<QuerySnapshot> _fetchData() {
    return firebaseMethods.userCollectionRef.collection('Notes').snapshots();
  }

  @override
  void initState() {
    super.initState();
    db = FirebaseFirestore.instance;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Today Tasks", style: TextStyle(color: Colors.white)),
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).cardColor,
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            children: [
              Flexible(
                child: Container(
                    padding: EdgeInsets.symmetric(vertical: 30, horizontal: 10),
                    child: StreamBuilder<QuerySnapshot>(
                      stream: _fetchData(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return (Center(
                            child: CircularProgressIndicator(),
                          ));
                        }

                        if (!snapshot.hasData) {
                          return (Center(
                            child: Text("Nothing present in database add data"),
                          ));
                        }

                        todayTasks = snapshot.data!.docs;

                        return ListView.builder(
                            itemCount: todayTasks.length,
                            itemBuilder: (context, index) {
                              var task = todayTasks[index].data()
                                  as Map<String, dynamic>;
                              var taskId = todayTasks[index].id;
                              var taskTitle = task['task'];
                              var taskDesc = task['description'];
                              var cDate = task['cDate'];

                              return Container(
                                margin: EdgeInsets.only(bottom: 15),
                                decoration: BoxDecoration(
                                    color: Color(0xFFEEEEFD),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15))),
                                child: ListTile(
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 5),
                                  leading: Container(
                                    margin: EdgeInsets.only(left: 20),
                                    child: Icon(Icons.task),
                                  ),
                                  title: Text(
                                    taskTitle,
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  subtitle: Text(taskDesc.length > 10 ? taskDesc.substring(0, 10) : taskDesc ,
                                      style: TextStyle(fontSize: 12)),
                                  trailing: IconButton(
                                    icon: Icon(Icons.delete_rounded),
                                    onPressed: () => _removeTask(taskId),
                                  ),
                                  onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => NotesInfo(
                                              taskId: taskId,
                                              title: taskTitle,
                                              desc: taskDesc,
                                              cDate:cDate,
                                          ))),
                                ),
                              );
                            });
                      },
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
