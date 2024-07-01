import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {

  Future<bool> addUserDetails(Map<String, dynamic> empMap) async {
    try {
      String userToCheck = empMap['email'];
      bool isUserAlreadyRegistered = await checkDuplication("users", "email", userToCheck);

      if (isUserAlreadyRegistered) {
        print("Data already registered: ${empMap['email']}, ${empMap['username']}");
        return false;
      } else {
        await FirebaseFirestore.instance.collection("users").add(empMap);
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
      CollectionReference collectionRef = FirebaseFirestore.instance.collection(collection);

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

      CollectionReference collectionRef = FirebaseFirestore.instance.collection('users');
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

      FirebaseFirestore.instance.collection("Tasks").add(taskData);
      print('Task added sucessfully');
      return true;
    }catch(e){
      print('Data not send exception : $e');
    }

    return false;
  }

}
