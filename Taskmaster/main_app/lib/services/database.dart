import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class DatabaseMethods {

  FirebaseFirestore db = FirebaseFirestore.instance;

  Future<bool> addUserDetails(Map<String, dynamic> empMap) async {
    try {
      String userToCheck = empMap['email'];
      bool isUserAlreadyRegistered = await checkDuplication("users", "email", userToCheck);

      if (isUserAlreadyRegistered) {
        print("Data already registered: ${empMap['email']}, ${empMap['username']}");
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


  Future<bool> checkDuplication(String collection, String attr, dynamic tocheckAttr) async {
    try {
      CollectionReference collectionRef = db.collection(collection);

      QuerySnapshot snapshot = await collectionRef.where(attr, isEqualTo: tocheckAttr).get();

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

  Future<bool> loginUer(dynamic tocheckAttr) async {
    try {

      CollectionReference collectionRef = db.collection('users');
      QuerySnapshot snapshot = await collectionRef.where("username", isEqualTo: tocheckAttr).get();

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

  Future<bool> addTask(Map<String,dynamic> taskData) async{

    try{
      db.collection("Tasks").add(taskData);
      db.collection("DailyTasks").add(taskData);
      print('Task added sucessfully');
      return true;
    }catch(e){
      print('Data not send exception : $e');
    }
    return false;
  }

  Future<bool> uploadTask(Map<String,dynamic> taskData,String collection) async{

    try{
      db.collection(collection).add(taskData);
      print('Task added sucessfully');
      return true;
    }catch(e){
      print('Data not send exception : $e');
    }
    return false;
  }


  Stream<QuerySnapshot> fetchData(String collectionName) {
    return db.collection(collectionName).snapshots();
  }

  Future<bool> delTask(String givenId , void Function(String) onTaskDeleted) async{

    try {
      await db.collection("TodayTasks").doc(givenId).delete();
      print('Task deleted successfully');
      onTaskDeleted(givenId);
      return true;
    } catch (e) {
      print('Data not deleted, exception : $e');
    }
    return false;
  }



}
