import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  State<Login> createState() => _loginstate();
}

class _loginstate extends State<Login> {
  Color MainThemeColor = Color(0xFF9565f4);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Login",
          style: TextStyle(color: Colors.white),
        ),
        elevation: 10.0,
        backgroundColor: MainThemeColor,
      ),
      body: Container(
          child: Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[

                Container(
                  margin: EdgeInsets.symmetric(horizontal: 30.0),
                  child: Column(
                    children: [
                      TextField(
                          decoration: InputDecoration(
                            hintText: "Username",
                            prefixIcon: Icon(Icons.person_2_rounded),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0)
                            ),
                          )
                      ),

                      Container(
                        margin: EdgeInsets.only(bottom: 40),
                      ),

                      TextField(
                          decoration: InputDecoration(
                            hintText: "Password",
                            prefixIcon: Icon(Icons.lock),
                            suffixIcon: Icon(Icons.remove_red_eye),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0)
                            ),
                          )
                      ),
                    ],
                  )

                )
              ],
            ),
          ),
        ),
    );
  }
}
