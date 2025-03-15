import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Signup extends StatefulWidget{
  @override
  State<Signup> createState() => SignupState();

}

class SignupState extends State<Signup>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text('signup'),
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).colorScheme.primary,
        titleTextStyle: TextStyle(color: Theme.of(context).colorScheme.onPrimary , fontSize: 20),
      ),
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,

          children: [
              TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.email_rounded),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.onPrimary,
                  labelText: 'Enter Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10)
                  )
                ),
              ),

            SizedBox(height: 20),

            TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.key),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.onPrimary,
                  labelText: 'Enter password',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)
                    )
                ),
              ),

            SizedBox(height: 20,),

            TextField(
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.password_rounded),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.onPrimary,
                  labelText: 'confirm password',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)
                    )
                ),
              ),

          ],
        ),
      ),

    );
  }

}