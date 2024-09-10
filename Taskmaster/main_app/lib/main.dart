import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:main_app/splashscreen.dart';
import 'package:main_app/firebase_options.dart';
import 'package:workmanager/src/workmanager.dart';
import 'package:workmanager/workmanager.dart';
import 'package:timezone/data/latest.dart' as tz;

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);

    CollectionReference source =
    FirebaseFirestore.instance.collection('DailyTasks');
    CollectionReference dest = FirebaseFirestore.instance.collection('Tasks');

    try {

      QuerySnapshot taskSnapshot = await dest.get();
      for(QueryDocumentSnapshot doc in taskSnapshot.docs){
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: mainColor,
        cardColor: taskColor,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false, // Set this to false
      home: splashscreen(),
    );
  }
}
