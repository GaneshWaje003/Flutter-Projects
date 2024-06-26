import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  FirebaseFirestore db = FirebaseFirestore.instance;

  Future<void> addUserDetails(Map<String, dynamic> empMap) async {
    try {

      String userToCheck = empMap['username'];
      bool isUserAlreadyRegistered = await checkDuplication("users", "usersname",userToCheck);

      if(isUserAlreadyRegistered){
        print("Data already registered");
      }else{
        await db.collection("users").add(empMap);
        print('Document added successfully');
      }


      
    } catch (e) {
      print('Error adding document: $e');
      // Handle any errors here
    }
  }

  Future<bool> checkDuplication(String Collection,String Attr , dynamic tocheckAttr) async{
      CollectionReference collectionRef = FirebaseFirestore.instance.collection(Collection);
      QuerySnapshot snapshot = await collectionRef.where(Attr,isEqualTo: tocheckAttr).get();

      if(snapshot.docs.isNotEmpty){
        print("User is present ");
        for(var doc in snapshot.docs){
          print(doc.id);
        }
      }else{
        return true;
      }

      return false;
  }

}
