import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';



class DatabaseMethods {
  late Query query;
  FirebaseAuth auth = FirebaseAuth.instance;
  late QuerySnapshot querySnapshot;
  User? user = FirebaseAuth.instance.currentUser;
  FirebaseFirestore db = FirebaseFirestore.instance;
  late CollectionReference ref;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  Future<bool> isUserPresent() async{

    if(user != null){
      return true;
    }
    return false;
  }

  // Future<bool> signInWithGoogle() async{
  //
  //   auth.
  //
  //   return false;
  // }

  Future<bool> addUserDetails(String email , String password) async {
    try {
      
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(email: email, password: password);
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
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
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
      var checkAttr = taskData['task'];
      var isDuplicate = await checkDuplication("CalenderTasks", 'task', checkAttr);

      if(!isDuplicate){
        db.collection(collection).add(taskData);
        print('Task added sucessfully');
        return true;
      }else{
        print('data is already present');
      }
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
      await db.collection("DailyTasks").doc(givenId).delete();
      await db.collection("Tasks").doc(givenId).delete();
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
      await db.collection("CalenderTasks").doc(givenId).delete().then((_){
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
      QuerySnapshot snapshot = await db
          .collection('Tasks')
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
      User? user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        print("User is null");
        return {
          'userName': 'Unknown',
          'userEmail': 'Unknown',
          'userPhotourl': null
        };
      } else {
        String? email = user.email ?? 'Unknown';
        String? userUrl = user.photoURL;
        String? userName = user.displayName;

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

  Future<List<QueryDocumentSnapshot>> fetchTaskData(String collection) async{
    List<QueryDocumentSnapshot> dataList=[];

    try{
      QuerySnapshot querySnapshot = await db.collection(collection).get();
      dataList = querySnapshot.docs;
      print("Data fetched for "+collection);
      return dataList;
    }catch(e){
      print("Exception while fetching data for "+collection);
    }



    return dataList;
  }



  Future<bool> logOut() async{
      await FirebaseAuth.instance.signOut();
      if(user == null){
        print("user logged out");
        return true;
      }
      return false;
  }


  Future<List<String>> getSpecificData(String collection , String attr) async{
      List<String> fList = [];

      QuerySnapshot snapshots = await db.collection(collection).get();

      fList = snapshots.docs.map((doc){
          var data = doc.data() as Map<String,dynamic>;
          return data['${attr}'] as String;
      }).toList();

      return fList;
  }


}
