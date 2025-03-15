import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FirebaseMethods {

  FirebaseStorage storageRef = FirebaseStorage.instance;
  FirebaseFirestore databaseRef = FirebaseFirestore.instance;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  late Firebase fb;
  final BuildContext context;

  FirebaseMethods({required this.context});

  Future<String> uploadImage(File image) async {
    try{
      final fileName = DateTime.now().millisecondsSinceEpoch.toString();
      final Reference storageReferences = storageRef.ref().child('images/$fileName.jpg');
      UploadTask uploadTask = storageReferences.putFile(image);
      await uploadTask.whenComplete(()=>null);
      String downloadUrl = await storageReferences.getDownloadURL();
      return downloadUrl;
    }catch(e){
      print(e.toString());
      return "";
    }
  }

  Future<void> uploadMenuToFirebase(String name,String desc ,String price ,String imgUrl ) async {
      try{
        databaseRef.collection('menuItem').add({
          'name':name,
          'desc':desc,
          'price':price,
          'imageUrl':imgUrl,
          'createdAt':FieldValue.serverTimestamp(),
        }).then((docRef)=>{
          print('document added with ID:${docRef.id}')
        });
      }catch(e){
          print(e.toString());
      }
  }

  Future<void> uploadMenuItem(File image , String name , String desc , String price) async {
    try{

      // uploading the image to storage and getting url link
      final String imgUrl = await uploadImage(image);

      //uploading menu realated data to the fiebase_firestore
      await uploadMenuToFirebase(name, desc, price, imgUrl);

    }catch(e){
      print(e.toString());
    }

  }

  Future<void> createUserWithEmail(String email, String password) async{
      try{
        firebaseAuth.createUserWithEmailAndPassword(email: email, password: password).then((userdata)=>{
          print('user created successfully with email ${userdata.user!.email}')
        });
      }catch(e){
        print('---------------------- error coming at creating user ${e.toString()}');
      }
  }

  Future<void> loginUserWithEmail(String email , String password) async{
    try {

      if(firebaseAuth.currentUser != null){
         await Fluttertoast.showToast(msg: 'User is already logged in ',toastLength: Toast.LENGTH_SHORT);
         Navigator.pushNamed(context, '/home');
      }else{
      firebaseAuth.signInWithEmailAndPassword(email: email, password: password).then((userdata)=>{
         Fluttertoast.showToast(msg: 'User logged in successfully',toastLength: Toast.LENGTH_SHORT)
      });
      }
    } on FirebaseAuthException catch(e){
      print(e.toString());
    }
  }

  Future<void> deleteInfo(List<String> deletedItemList) async{

    // collection reference getting
    CollectionReference collRef = databaseRef.collection('menuItem');

    // creating a batch file
    WriteBatch batch = databaseRef.batch();

    // getting all querysnapshots
    QuerySnapshot querySnapshot = await collRef.get();

    deletedItemList.forEach((deletedItem){
        var docToDelete = querySnapshot.docs.firstWhere((doc)=> doc.id == deletedItem );

        if(docToDelete != null){
          DocumentReference docRef = docToDelete.reference;
          batch.delete(docRef);
        }
    });

    await batch.commit();

  }

  Future<void> logoutUser() async{
      try{
        firebaseAuth.signOut().then((user)=>{
          print(" user logged out succesfully ")
        });

      }catch(e){
        print(e.toString());
      }
  }

}