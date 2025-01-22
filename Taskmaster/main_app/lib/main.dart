import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:main_app/Login.dart';
import 'package:main_app/alarmData.dart';
import 'package:main_app/alarmPage.dart';
import 'package:main_app/firebase_options.dart';
import 'package:main_app/mainPage.dart';
import 'package:main_app/notifactionService.dart';
import 'package:main_app/services/database.dart';
import 'package:main_app/settingScreens/aobut.dart';
import 'package:main_app/settingScreens/language.dart';
import 'package:main_app/settingScreens/passwordManager.dart';
import 'package:main_app/signup.dart';
import 'package:main_app/splashscreen.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:workmanager/src/workmanager.dart';
import 'package:workmanager/workmanager.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
DatabaseMethods db = DatabaseMethods();
GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
// TaskPage tp = TaskPage();

// Alarm time variables
List<AlarmData> _AlarmTime = [];
late NotifactionServices nf = NotifactionServices();
DateTime now = DateTime.now();

void _getTasksDates() async {
  _AlarmTime = await db.getAlarmData();
  print(
      'This are the Alarm Dates ${_AlarmTime[0].taskTitle} , ${_AlarmTime[0].alarmTime}');
}

void showNotificationPage(String title) {
  navigatorKey.currentState?.push(
      MaterialPageRoute(builder: (context) => AlarmPage(taskTitle: title)));
}

void _startAlarmChecking() {
  Timer.periodic(Duration(minutes: 1), (timer) {
    final nowUtc = DateTime.now().toUtc();
    for (var alarmTime in _AlarmTime) {
      final utcAlarmTime = alarmTime.alarmTime.toUtc();

      if (utcAlarmTime.isAfter(nowUtc.subtract(Duration(minutes: 1))) &&
          utcAlarmTime.isBefore(nowUtc.add(Duration(seconds: 60)))) {
        nf.scheduleAlarm(alarmTime.alarmTime, alarmTime.taskTitle,
            alarmTime.taskDescription);
        showNotificationPage(alarmTime.taskTitle);
        _AlarmTime.remove(alarmTime);
        print("alarm time matched");
      } else {
        print('time dont match');
      }
    }
  });
}

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);

    _startAlarmChecking();

    CollectionReference source =
        FirebaseFirestore.instance.collection('DailyTasks');
    CollectionReference dest = FirebaseFirestore.instance.collection('Tasks');

    try {
      QuerySnapshot taskSnapshot = await dest.get();
      for (QueryDocumentSnapshot doc in taskSnapshot.docs) {
        await dest.doc(doc.id).delete();
      }
      print('Data Deleted');

      QuerySnapshot querySnapshot = await source.get();
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        await dest.doc(doc.id).set(doc.data() as Map<String, dynamic>);
      }
      print('Data updated');
    } catch (e) {
      print('Error white workmanager : $e \nerror\nerror]\nerror\nerror');
    }
    return Future.value(true);
  });
}

void main() async {

  tz.initializeTimeZones();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Color(0xFF112233), // Status bar color
    statusBarIconBrightness: Brightness.light, // Status bar icons color
  ));
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  _getTasksDates();
  _startAlarmChecking();

  Workmanager().initialize(
    callbackDispatcher,
  );

  Workmanager().registerPeriodicTask('1', 'simpleTaskName',
      frequency: Duration(minutes: 3));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const Color mainColor = Color(0xFF9565f4);
  static const Color taskColor = Color(0xFF112233);
  static const Color listColor = Color(0xFFEEEEFD);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      navigatorKey: navigatorKey,
      theme: ThemeData(
        cardColor: taskColor,
        colorScheme: ColorScheme(
          tertiary: listColor,
          brightness: Brightness.light,
          primary: Color(0xFF112233),
          onPrimary: Colors.white,
          secondary: Colors.amber,
          onSecondary: Colors.black,
          surface: Colors.white,
          error: Colors.red,
          onError: Colors.white,
          onSurface: Colors.black,
        ),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      // Set this to false
      home: splashscreen(),

      initialRoute: '/',
      routes: {
        '/login':(context)=>Login(),
        '/signup':(context)=>Signup(),
        '/home':(context)=>Mainpage(),
        '/language':(context)=>Language(),
        '/about':(context)=>About(),
        '/passwordManager':(context)=>PasswordManager(),
      },

    );
  }
}
