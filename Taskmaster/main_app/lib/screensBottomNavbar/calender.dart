import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:main_app/calenderInfo.dart';
import 'package:main_app/globalState.dart';
import 'package:main_app/services/database.dart';
import 'package:table_calendar/table_calendar.dart';

class CalenderPage extends StatefulWidget {
  @override
  State<CalenderPage> createState() => _calenderPage();
}

class _calenderPage extends State<CalenderPage> {

  FirebaseFirestore db = FirebaseFirestore.instance;
  DatabaseMethods databaseMethods = DatabaseMethods();
  List<DateTime> dateList= [];
  List<String> stringDateList= [];
  List<QueryDocumentSnapshot> calList = [];

  DateTime _todayDate = DateTime.now();

  // void _fetchDates() async{
  //   stringDateList = await databaseMethods.getSpecificData('CalenderTasks', 'date');
  //  setState(() {
  //    dateList =  stringDateList.map((date){
  //      return DateTime.parse(date);
  //    }).toList();
  //  });
  // }

  void _onDayselected(DateTime day, DateTime focusedDay) {
    setState(() {
      _todayDate = day;
        GlobalState().selectedDate = _todayDate;
    });
  }

  void _fetchAttr(){

  }
  void changePage(String taskId ,String taskTitle, String taskDate) {

    TextStyle whiteStyle = TextStyle(color: Colors.white);
    TextStyle darkStyle = TextStyle(color: Theme.of(context).cardColor);

    // Navigator.push(context,MaterialPageRoute(builder: (context)=>CalenderInfo(taskId: taskId,task: taskTitle, dateTime: taskDate)));

    showDialog(context: context, builder: (BuildContext context){
      return AlertDialog(
        title: Text('daywise tasks',style: whiteStyle,),
        content:Text(taskTitle,style: whiteStyle,) ,
        backgroundColor: Theme.of(context).cardColor,
        actions: [
          TextButton(onPressed: (){}, child: Text('Yes',style: whiteStyle,)),
          ElevatedButton(onPressed: (){}, child: Text('No',style: darkStyle,))
        ],
      );
    });
  }


  void _fetchCalTasks() async {
    // QuerySnapshot s =   db.collection("CalenderTasks").snapshots() ;
  }

  void getCalenderData() async{
    calList = await databaseMethods.fetchTaskData('CalenderTasks');
    setState(() {}); // Call setState to rebuild the widget with the updated data
  }

  void _listenToCalenderTasks() {
    db.collection("CalenderTasks").snapshots().listen((snapshot) {
      setState(() {
        calList = snapshot.docs;
        dateList = calList.map((doc) {
          var data = doc.data() as Map<String, dynamic>;
          return DateTime.parse(data['date']);
        }).toList();
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _fetchDates();
    _listenToCalenderTasks();
    getCalenderData();
  }

  final Color listColor = Color(0xFFEEEEFD);

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
                  titleTextStyle: TextStyle(color: Colors.white),
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
                calendarBuilders: CalendarBuilders(
                  markerBuilder: (context,date,events){
                        if(dateList.contains(date)){
                          return Container(
                              decoration: BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle

                              ),
                              width: 35,
                              height: 35,
                              child: Center(child:Text('${date.day}',style: TextStyle(color: Colors.white),)),
                          );
                        }
                  }
                ),
                availableGestures: AvailableGestures.all,
                focusedDay: DateTime.now(),
                firstDay: DateTime.utc(2024, 6, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                onDaySelected: _onDayselected,
                selectedDayPredicate: (day) => isSameDay(day, _todayDate),
              ),
              Container(
                child: Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(vertical: 10),
                  child: Text(
                      'Select Date : $_todayDate'),
                ),
              ),
              Flexible(
                child:
                    ListView.builder(
                        itemCount: calList.length,
                        itemBuilder: (context, index) {
                          var task = calList[index].data() as Map<String,dynamic> ;
                          final taskId = calList[index].id;
                          final taskTitle = task['task'] ?? "-";
                          final taskDate = task['date'] ?? '-';

                          return Container(
                            margin: EdgeInsets.symmetric(vertical: 5,horizontal: 5),
                            decoration: BoxDecoration(
                                color: listColor,
                                borderRadius: BorderRadius.all(Radius.circular(15.0)),
                            ),
                            child: ListTile(
                              contentPadding: EdgeInsets.only(right: 0,left: 20.0 , ),
                              title: Text(
                                taskTitle,
                                style: TextStyle(color: Colors.black),
                              ),
                              subtitle: Text(taskDate,
                                  style: TextStyle(color: Colors.black)),
                              onTap: ()=> changePage(taskId, taskTitle,taskDate),

                              trailing: Container(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(onPressed: (){}, icon: Icon(Icons.delete_rounded)),
                                    IconButton(onPressed: (){}, icon: Icon(Icons.more_vert_rounded)),
                                  ],
                                ),
                              )
                            ),

                          );
                        }
                        )

              ),
            ],
          ),
        ),
      ),
    );
  }

}
