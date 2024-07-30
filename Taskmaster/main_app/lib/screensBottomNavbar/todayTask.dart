import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:main_app/services/database.dart';

class TodayTask extends StatefulWidget {
  @override
  State<TodayTask> createState() => _TodayTaskState();
}

class _TodayTaskState extends State<TodayTask> {

  List<QueryDocumentSnapshot> todayTasks = [];
  DatabaseMethods firebaseMethods = DatabaseMethods();
  var _selectedTaskId;

  void _removeTask(String taskId) {
    setState(() {
      todayTasks.removeWhere((task) => task.id == taskId);
    });
  }

  @override
  Widget build(BuildContext contex) {
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
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 30,horizontal: 10),
                    child: StreamBuilder<QuerySnapshot>(
                  stream: firebaseMethods.fetchData('TodayTasks'),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
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
                          var task =
                              todayTasks[index].data() as Map<String, dynamic>;
                          var taskId = todayTasks[index].id;

                          return Container(
                            margin: EdgeInsets.only(bottom: 15),
                            decoration: BoxDecoration(
                                color: Color(0xFFEEEEFD),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15))),
                            child: ListTile(
                              contentPadding: EdgeInsets.symmetric(vertical: 5),
                              leading: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black),
                                  borderRadius: BorderRadius.all(Radius.circular(50)),
                                ),
                                width: 40,
                                height: 40,
                                margin: EdgeInsets.symmetric(horizontal: 10),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.all(Radius.circular(50)),
                                    child: Image.asset('assets/ronaldo_potrait.jpeg',fit: BoxFit.cover,)),
                              ),
                              title: Text(
                                task['task'],
                                style: TextStyle(fontSize: 18),
                              ),
                              trailing: IconButton(
                                icon: Icon(Icons.delete_rounded),
                                onPressed: ()  async {
                                  bool isDelted = await firebaseMethods.delTask(taskId,_removeTask) as bool;
                                  if (!isDelted) {
                                    print("data not delted");
                                  }
                                },
                              ),
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







