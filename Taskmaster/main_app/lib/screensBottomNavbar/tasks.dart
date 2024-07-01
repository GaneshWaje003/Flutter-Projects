import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class TaskPage extends StatefulWidget {
  @override
  State<TaskPage> createState() => _taskPage();
}

class _taskPage extends State<TaskPage> {

  FirebaseFirestore db = FirebaseFirestore.instance;

  List<String> taskList = [];

  var _selectedTaskId;

  @override
  void initState() {

    super.initState();
  }

  Stream<QuerySnapshot> _fetchData(){
      return db.collection('Tasks').snapshots();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 40),
            width: double.infinity,
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(20))),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      // padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white,
                      ),
                      child: IconButton(
                        icon: Icon(Icons.arrow_back_ios_new_rounded,color: Theme.of(context).primaryColor,),
                        onPressed: () {

                        }),
                    ),

                    Container(
                      child: Icon(Icons.menu_rounded,color: Colors.white,),
                    ),
                  ],
                ),

                Container(
                  margin: EdgeInsets.only(top: 50),
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
                                    Text("Completed Task",style:TextStyle(color:Colors.white,fontSize: 30)),
                                    Container(margin: EdgeInsets.only(left: 3),child: Text("Keep it up 😊",style:TextStyle(color:Colors.white,fontSize: 15)))
                                  ],
                                ),
                              ),

                              Container(
                                margin: EdgeInsets.only(left: 30),
                                child: CircularPercentIndicator(
                                  radius: 40,
                                  lineWidth: 8,
                                  percent: 0.8,
                                  circularStrokeCap: CircularStrokeCap.round,
                                  progressColor: Colors.green,
                                  backgroundColor: Colors.white,
                                  center:
                                  Center(
                                    child: Container(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text("10",style:TextStyle(color: Colors.white,fontSize: 18)),
                                          Text('/',style:TextStyle(color: Colors.white,fontSize: 18)),
                                          Text("8",style:TextStyle(color: Colors.white,fontSize: 18)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                      ),
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
                builder: (context,snapshot){
                    if(snapshot.connectionState == ConnectionState.waiting){
                      return Center(child:CircularProgressIndicator());
                    }

                    if(!snapshot.hasData){
                      return Center(child: Text("No Data Found"));
                    }

                    final tasks = snapshot.data!.docs;

                    return ListView.builder(
                      itemCount: tasks.length,
                      itemBuilder: (context,index){
                          var task = tasks[index].data() as Map<String,dynamic>;
                          return  Container(
                            margin: EdgeInsets.only(bottom: 15),
                            decoration: BoxDecoration(
                              color: Colors.blue[100],
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 2,
                                  spreadRadius: 1,
                                  offset: Offset(0,3)
                                )
                              ],
                              borderRadius: BorderRadius.all(Radius.circular(15))
                            ),
                            child: ListTile(
                              leading: Radio<String>(
                                value: tasks[index].id,
                                groupValue: _selectedTaskId,
                                onChanged: (String? value){
                                  setState(() {
                                    _selectedTaskId = value;
                                  });
                                },
                              ),
                              title: Text(task['task'],style: TextStyle(fontSize: 18),),
                              subtitle: Text(task['hour']+" : "+task['min']+" "+task['ampm']),
                              trailing: IconButton(
                                icon: Icon(Icons.delete_rounded),
                                onPressed: (){
                                  db.collection("Tasks").doc(tasks[index].id).delete();
                                },
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
    ));
  }
}
