import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:main_app/alarmData.dart';

class DatabaseMethods {
  late Query query;
  FirebaseAuth auth = FirebaseAuth.instance;
  late QuerySnapshot querySnapshot;
  User? user = FirebaseAuth.instance.currentUser;
  FirebaseFirestore db = FirebaseFirestore.instance;
  late CollectionReference ref;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  String? userId;
  var userCollectionRef;

  DatabaseMethods(){
    if(userId == null){
      initUser();
    }
  }

  Future<void> initUser() async {
    try {
      if (auth.currentUser != null) {
        userId = auth.currentUser?.uid ?? "";
        userCollectionRef = db.collection('users').doc(userId);
        print("user intialized with uid : $userId");
      }else{
        print("intiUser() : \n not authenticated user found\n");
        throw Exception("authendticated user not found \n");
      }
    } catch (e) {
      print('Exception while initUser methods : \n $e');
    }
  }

  Future<bool> isUserPresent() async {
    if (user != null) {
      return true;
    }
    return false;
  }

  Future<bool> addUserDetails(
      String email, String password, String username) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
          email: email, password: password);

      String? userIdRef = userCredential.user?.uid;

      if (userIdRef == null || userIdRef.isEmpty) {
        throw Exception(
            "User ID is null or empty. Ensure the user is logged in.");
      }

      db.collection("users").doc(userIdRef).set({
        "uid": userIdRef,
        "username": username,
        "email": email,
        "password": password
      });

      initUser();

      print('User is created ${userCredential.user}');
      return true;
    } on FirebaseAuthException catch (e) {
      print('Error Creating a user: $e');
      // Handle any errors here
    }
    return false;
  }

  Future<bool> checkDuplication(
      String collection, String attr, dynamic tocheckAttr) async {
    try {
      ref = db.collection(collection);
      querySnapshot = await ref.where(attr, isEqualTo: tocheckAttr).get();

      if (querySnapshot.docs.isNotEmpty) {
        print("User is present");
        for (var doc in querySnapshot.docs) {
          print(doc.id);
        }
        return true; // Indicates duplication found
      } else {
        print("User not found");
        return false; // Indicates no duplication
      }
    } catch (e) {
      print('Error checking duplication: $e');
      return false; // Handle errors gracefully
    }
  }

  Future<String> loginUser(String email, String password) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        print("User is successfully logged in");
        return "Login successful";
      } else {
        print("Login failed");
        return "Login failed";
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
        return 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
        return 'Wrong password provided for that user.';
      } else {
        print('Login failed: ${e.message}');
        return 'Login failed: ${e.message}';
      }
    } catch (e) {
      print('Error: $e');
      rethrow; // Re-throw the exception for further handling
    }
  }

  Future<bool> addTask(Map<String, dynamic> taskData) async {
    try {

      var taskToCheck = taskData['task'];
      bool isDataOk = await checkDuplication("Tasks", "task", taskToCheck);
      if (isDataOk) {
        print('Task not added , duplicate data');
        return false;
      } else {
        userCollectionRef.collection("Tasks").add(taskData);
        userCollectionRef.collection("DailyTasks").add(taskData);
        print('Task added sucessfully');
        return true;
      }
    } catch (e) {
      print('Data not send exception : $e');
    }
    return false;
  }

  Future<bool> uploadTask(
      Map<String, dynamic> taskData, String collection) async {
    try {
      var checkAttr = taskData['task'];
      var isDuplicate =
          await checkDuplication("CalenderTasks", 'task', checkAttr);

      if (!isDuplicate) {
        userCollectionRef.collection(collection).add(taskData);
        print('Task added sucessfully');
        return true;
      } else {
        print('data is already present');
      }
    } catch (e) {
      print('Data not send exception : $e');
    }
    return false;
  }

  Stream<QuerySnapshot> fetchData(String collectionName) {
    return userCollectionRef.collection(collectionName).snapshots();
  }

  Future<bool> delTask(String givenId, String collection,
      void Function(String) onTaskDeleted) async {
    try {
      if (collection == 'Tasks') {
        await userCollectionRef.collection("DailyTasks").doc(givenId).delete();
      }

      await userCollectionRef.collection(collection).doc(givenId).delete();

      print('Task deleted successfully');
      onTaskDeleted(givenId);
      return true;
    } catch (e) {
      print('Data not deleted, exception : $e');
    }
    return false;
  }

  Future<bool> delCalTask(
      String givenId, void Function(String) onTaskDeleted) async {
    try {
      await userCollectionRef
          .collection("CalenderTasks")
          .doc(givenId)
          .delete()
          .then((_) {
        print('Task deleted successfully');
        onTaskDeleted(givenId);
        return true;
      });
    } catch (e) {
      print('Data not deleted, exception : $e');
    }
    return false;
  }

  Future<List<QueryDocumentSnapshot>> searchTasks(String taskTitle) async {
    try {
      QuerySnapshot snapshot = await userCollectionRef
          .collection('Tasks')
          .where('task', isEqualTo: taskTitle)
          .get();

      return snapshot.docs; // List of documents with the matching task title
    } catch (e) {
      print('Error searching tasks: $e');
      return [];
    }
  }

  Future<void> updateData(
      String docId, String collection, Map<String, dynamic> data) async {
    if (collection == 'Tasks') {
      userCollectionRef
          .collection('DailyTasks')
          .doc(docId)
          .update(data)
          .then((_) {
        print('TodayTasks udpated ');
      });
    }

    var tasktitle = data['task'];
    userCollectionRef.collection(collection).doc(docId).update(data).then((_) {
      print('$tasktitle udpated ');
    });
  }

  Future<Map<String, dynamic>> getUserData() async {
    try {
      initUser();
      DocumentSnapshot userDoc =  await userCollectionRef.get();

      if (user == null) {
        print("User is null");
        return {
          'userName': 'Unknown',
          'userEmail': 'Unknown',
          'userPhotourl': null
        };
      } else {
        String? email = user?.email ?? 'Unknown';
        String? userUrl = user?.photoURL;
        String? userName = userDoc.get('username');

        return {
          'userName': userName ?? 'Unknown',
          'userEmail': email,
          'userPhotourl': userUrl
        };
      }
    } catch (e) {
      print('Error: $e');
      return {'userName': 'Error', 'userEmail': 'Error', 'userPhotourl': null};
    }
  }

  Future<List<QueryDocumentSnapshot>> fetchTaskData(String collection) async {
    List<QueryDocumentSnapshot> dataList = [];

    try {
      QuerySnapshot querySnapshot =
          await userCollectionRef.collection(collection).get();
      dataList = querySnapshot.docs;
      print("Data fetched for " + collection);
      return dataList;
    } catch (e) {
      print("Exception while fetching data for " + collection);
    }

    return dataList;
  }

  Future<bool> logOut() async {
    await FirebaseAuth.instance.signOut();
    if (user == null) {
      print("user logged out");
      return true;
    }
    return false;
  }

  Future<List<String>> getSpecificData(String collection, String attr) async {
    List<String> fList = [];

    QuerySnapshot snapshots =
        await userCollectionRef.collection(collection).get();

    fList = snapshots.docs.map((doc) {
      var data = doc.data() as Map<String, dynamic>;
      return data['${attr}'] as String;
    }).toList();

    return fList;
  }

  Future<List<AlarmData>> getAlarmData() async {
    List<AlarmData> flist = [];

    try {
      querySnapshot = await userCollectionRef.collection('Tasks').get();

      flist = querySnapshot.docs.map((doc) {
        var data = doc.data() as Map<String, dynamic>;

        var hour = int.tryParse(data['hour']!.toString()) ?? 0;
        final minute = int.tryParse(data['min']!.toString()) ?? 0;
        final task =
            data['task']?.toString() ?? 'No Task'; // Default if missing
        final description =
            data['description']?.toString() ?? ''; // Empty string if missing

        final ampm = data['ampm']?.toString().toUpperCase();

        if (ampm == 'AM' && hour == 12) {
          hour = 0;
        } else if (ampm == 'PM' && hour < 12) {
          hour += 12; // Adjust for hours after noon
        }

        final alarmTime = TimeOfDay(hour: hour, minute: minute);
        final today = DateTime.now();
        final alarmDate = DateTime(today.year, today.month, today.day,
            alarmTime.hour, alarmTime.minute);
        print('alarm data : ${alarmDate}');

        return AlarmData(
            alarmTime: alarmDate,
            taskTitle: task,
            taskDescription: description);
      }).toList();
      flist.removeWhere((element) => element == null);
    } catch (e) {
      print('getAlarmData : ${e}');
    }
    return flist;
  }
}
