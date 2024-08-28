import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:main_app/screensBottomNavbar/setting.dart';

class DatabaseMethods {
  late Query query;
  late QuerySnapshot querySnapshot;
  FirebaseFirestore db = FirebaseFirestore.instance;
  late CollectionReference ref;
  User? user = FirebaseAuth.instance.currentUser;

  Future<bool> addUserDetails(Map<String, dynamic> empMap) async {
    try {
      String userToCheck = empMap['email'];
      bool isUserAlreadyRegistered =
          await checkDuplication("users", "email", userToCheck);

      if (isUserAlreadyRegistered) {
        print(
            "user already registered: ${empMap['email']}, ${empMap['username']}");
        return false;
      } else {
        await db.collection("users").add(empMap);
        print('Document added successfully');
        return true;
      }
    } catch (e) {
      print('Error adding document: $e');
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

  Future<bool> loginUer(dynamic tocheckAttr) async {
    try {
      CollectionReference collectionRef = db.collection('users');
      QuerySnapshot snapshot =
          await collectionRef.where("username", isEqualTo: tocheckAttr).get();

      if (snapshot.docs.isNotEmpty) {
        print("User is present");
        for (var doc in snapshot.docs) {
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

  Future<bool> addTask(Map<String, dynamic> taskData) async {
    try {
      var taskToCheck = taskData['task'];
      bool isDataOk = await checkDuplication("Tasks", "task", taskToCheck);
      if (isDataOk) {
        print('Task not added , duplicate data');
        return false;
      } else {
        db.collection("Tasks").add(taskData);
        db.collection("DailyTasks").add(taskData);
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
      db.collection(collection).add(taskData);
      print('Task added sucessfully');
      return true;
    } catch (e) {
      print('Data not send exception : $e');
    }
    return false;
  }

  Stream<QuerySnapshot> fetchData(String collectionName) {
    return db.collection(collectionName).snapshots();
  }

  Future<bool> delTask(
      String givenId, void Function(String) onTaskDeleted) async {
    try {
      await db.collection("TodayTasks").doc(givenId).delete();
      await db.collection("Tasks").doc(givenId).delete();
      print('Task deleted successfully');
      onTaskDeleted(givenId);
      return true;
    } catch (e) {
      print('Data not deleted, exception : $e');
    }
    return false;
  }

  Future<bool> delTaskWithTitle(String taskTitle) async {
    try {
      ref = FirebaseFirestore.instance.collection('Tasks');
      query = ref.where('task', isEqualTo: taskTitle);
      querySnapshot = await query.get();

      if (querySnapshot.docs.isNotEmpty) {
        for (var doc in querySnapshot.docs) {
          await doc.reference.delete();
          print('Task deleted successfully: ${doc.id}');
        }
        return true;
      } else {
        print('No tasks found with the title: $taskTitle');
        return false;
      }
    } catch (e) {
      print('Error in delTaskWithTitle: $e');
      return false;
    }
  }

  Future<List<QueryDocumentSnapshot>> searchTasks(String taskTitle) async {
    try {
      QuerySnapshot snapshot = await db
          .collection('tasks')
          .where('task', isEqualTo: taskTitle)
          .get();

      return snapshot.docs; // List of documents with the matching task title
    } catch (e) {
      print('Error searching tasks: $e');
      return [];
    }
  }

  Future<void> updateData(String docId, Map<String, dynamic> data) async {
    // ref = FirebaseFirestore.instance.collection('Task').doc(docId)

    var tasktitle = data['task'];
    db.collection('Tasks').doc(docId).update(data).then((_) {
      print('$tasktitle udpated ');
    });
  }

  Future<Map<String, dynamic>> getUserData() async {
    try {
      if (user == null) {
        print("User is null");
        return {
          'userName': 'Unknown',
          'userEmail': 'Unknown',
          'userPhotourl': null
        };
      } else {
        String? email = user!.email ?? 'Unknown';
        String? userUrl = user!.photoURL;
        String? userName = user!.displayName;

        return {
          'userName': userName ?? 'Unknown',
          'userEmail': email,
          'userPhotourl': userUrl
        };
      }
    } catch (e) {
      print('Error: $e');
      return {
        'userName': 'Error',
        'userEmail': 'Error',
        'userPhotourl': null
      };
    }
  }

}
