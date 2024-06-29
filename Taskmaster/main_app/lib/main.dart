  import 'package:firebase_core/firebase_core.dart';
  import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
  import 'package:main_app/splashscreen.dart';
  import 'package:main_app/firebase_options.dart';

  void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform
    ); // Initialize Firebase
    runApp(const MyApp());
  }

  class MyApp extends StatelessWidget {
    const MyApp({super.key});

      static const Color mainColor = Color(0xFF9565f4);
    @override
    Widget build(BuildContext context) {

      return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primaryColor:mainColor ,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false, // Set this to false
        home: splashscreen(),

      );

    }
  }
