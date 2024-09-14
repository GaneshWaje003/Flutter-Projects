import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotifactionServices{

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  NotifactionServices(){
    _initialize();
  }

  Future<void> _initialize() async{
      tz.initializeTimeZones();
      const AndroidInitializationSettings androidSetting = AndroidInitializationSettings('app_icon');
      final InitializationSettings initializationSettings =  InitializationSettings(android: androidSetting);
      flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> scheduleAlarm(DateTime dates,String task,String desc) async{

    DateTime today = DateTime.now();
    DateTime alarmDate = DateTime(today.year,today.month,today.day,dates.hour,dates.minute);
    int alarmId = alarmDate.hashCode;

    AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
        'task_alarm_channel',
        'task_alarm',
        channelDescription: desc,
        importance: Importance.max,
        priority: Priority.high,
        showWhen: true
    );

    NotificationDetails platFormDetails = NotificationDetails(android: androidNotificationDetails);
    flutterLocalNotificationsPlugin.zonedSchedule(alarmId,task, desc, tz.TZDateTime.from(alarmDate, tz.local),platFormDetails , androidAllowWhileIdle: true, uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime);

  }
}