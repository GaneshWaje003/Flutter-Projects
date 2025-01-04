import 'package:flutter/material.dart';
import 'package:main_app/alarmPage.dart';
import 'package:main_app/dialogs/calenderDialog.dart';
import 'package:main_app/dialogs/taskDialog.dart';
import 'package:main_app/dialogs/notesDialog.dart';
import 'package:main_app/screensBottomNavbar/calender.dart';
import 'package:main_app/screensBottomNavbar/setting.dart';
import 'package:main_app/screensBottomNavbar/tasks.dart';
import 'package:main_app/screensBottomNavbar/notes.dart';

class Mainpage extends StatefulWidget {
  @override
  State<Mainpage> createState() => _MainPageState();
}

class _MainPageState extends State<Mainpage> {

  Color mainThemeColor = Color(0xFF9565f4);
  int _selectedIndex = 0;

  // List of screens to display
  final List<Widget> _screens = [
    TaskPage(),
    CalenderPage(),
    Notes(),
    Setting(),
  ];

  void _onItemPress(int index) {
    setState(() {
      _selectedIndex = index; 
      print('Selected index: $index');
    });
  }

  void _showDialog(){
    if(_selectedIndex == 0){
      showModalBottomSheet(context: context, builder:(context)=>Taskdialog());
    }else if(_selectedIndex == 1){
      showModalBottomSheet(context: context, builder: (context)=>CalenderDialog());
    }else if(_selectedIndex == 2){
      // Navigator.push(context: context, builder: (context)=> TodayTaskDialog());
      Navigator.push(context, MaterialPageRoute(builder: (context)=>TodayTaskDialog()));
    }else{
      showModalBottomSheet(context: context, builder: (context)=> Taskdialog());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),

      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.task_alt_outlined),
            label: "Todo",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month_rounded),
            label: "Calendar",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_alert_rounded),
            label: "Notes",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: "Settings",
          ),
        ],

        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).cardColor,
        unselectedItemColor: Colors.grey,
        onTap: _onItemPress,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: TextStyle(fontSize: 12),
        unselectedLabelStyle: TextStyle(fontSize: 12),
      ),

      floatingActionButton:
      AnimatedSwitcher(
        duration: Duration(milliseconds: 200),

        child: _selectedIndex != 3 ? FloatingActionButton(
          backgroundColor: Theme.of(context).cardColor,
          elevation: 10,
          shape: CircleBorder(),
          child: Icon(
            Icons.add,
            color: Colors.white,
            size: 30,
          ),
          onPressed: _showDialog
      ):null,
    ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

}