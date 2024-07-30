import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalenderPage extends StatefulWidget {
  @override
  State<CalenderPage> createState() => _calenderPage();
}

class _calenderPage extends State<CalenderPage> {

  FirebaseFirestore db = FirebaseFirestore.instance;

  DateTime _todayDate = DateTime.now();

  void _onDayselected(DateTime day, DateTime focusedDay) {
    setState(() {
      _todayDate = day;
    });
  }

  Stream<QuerySnapshot> _fetchCalTasks(){
      return db.collection("CalTasks").snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
          child: Column(
            children: [
              TableCalendar(
                rowHeight: 40,
                headerStyle: HeaderStyle(
                  titleCentered: true,
                  titleTextStyle: TextStyle(
                    color: Colors.white
                  ),
                  headerMargin: EdgeInsets.only(bottom: 10),
                  formatButtonVisible: false,
                  leftChevronIcon: Icon(
                    Icons.chevron_left,
                    color: Colors.white,
                  ),
                  rightChevronIcon: Icon(
                    Icons.chevron_right,
                    color: Colors.white,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                ),
                availableGestures: AvailableGestures.all,
                focusedDay: DateTime.now(),
                firstDay: DateTime.utc(2024, 6, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                onDaySelected: _onDayselected,
                selectedDayPredicate: (day) => isSameDay(day, _todayDate),
              ),
              Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream:_fetchCalTasks(),
                      builder: (context,snapshot){

                      if(snapshot.connectionState == ConnectionState.waiting){
                        return Center(child: CircularProgressIndicator());
                      }

                      if(!snapshot.hasData){
                        return Center(child: Text("No Data added to Database"),);
                      }

                      final tasks = snapshot.data!.docs;

                        return ListView.builder(
                            itemCount: tasks.length,
                            itemBuilder: (context,index){
                              var  task = tasks[index].data() as Map<String,dynamic>;
                              return ListTile(
                                  title: task['task'],
                                  subtitle: task['date'],
                              );
                            }
                        );
                    },
                  )
              )
            ],
          ),
        ),
      ),
    );
  }
}
