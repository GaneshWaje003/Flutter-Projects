import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  State<Login> createState() => _loginstate();
}

class _loginstate extends State<Login> {
  Color MainThemeColor = Color(0xFF9565f4);
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  final _key = GlobalKey<FormState>();

  void loginUser() {
    if (_key.currentState!.validate()) {
      // If the form is valid, proceed with the login logic
      print('Username: ${_usernameController.text}');
      print('Password: ${_passwordController.text}');
    }
  }

  @override
  void dispose() {
    // Dispose the controllers when the widget is disposed
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
          child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: 200),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: MainThemeColor,
          ),

          child: Container(
              child: Container(
              padding: EdgeInsets.only(top: 20), decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight:Radius.circular(20),bottomLeft:Radius.circular(0),bottomRight: Radius.circular(0))
              ),
              child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(bottom: 5),
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Align(
                    child: Text("Welcome", style: TextStyle(fontSize: 25)),
                    alignment: Alignment.topLeft,
                  ),
                ),

                Container(
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Align(
                    child: Text("Fill correct data for succesful login", style: TextStyle(fontSize: 16)),
                    alignment: Alignment.topLeft,
                  ),
                ),

                Container(
                  margin:EdgeInsets.only(bottom: 30),
                  padding: EdgeInsets.symmetric(horizontal: 30),
                  child: Align(
                    child: Text("and taskmaster will arrange your day", style: TextStyle(fontSize: 16)),
                    alignment: Alignment.topLeft,
                  ),
                ),

                Form(
                  key: _key,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 30.0),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _usernameController,
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.symmetric(vertical: 15),
                            hintText: "Username",
                            prefixIcon: Icon(Icons.person_2_rounded),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your username';
                            }
                            return null;
                          },
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 40),
                        ),
                        TextFormField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            hintText: "Password",
                            contentPadding: EdgeInsets.symmetric(vertical: 15),
                            prefixIcon: Icon(Icons.lock),
                            suffixIcon: Icon(Icons.remove_red_eye),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0)),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            } else if (value.length < 8) {
                              return 'Password should be greater than 7 chars';
                            }
                            return null;
                          },
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: Text("Forgot Password ?",
                              style: TextStyle(
                                color: Colors.blueAccent,
                              )),
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  margin: EdgeInsets.symmetric(horizontal: 30, vertical: 70),
                  child: ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(MainThemeColor),
                        padding: MaterialStateProperty.all(
                            EdgeInsets.symmetric(vertical: 10)),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                      ),
                      onPressed: () {
                        loginUser();
                      },
                      child: Text(
                        "Login",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      )),
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 0),
                  child: TextButton(
                    onPressed: () {

                    },
                    child: Text("New to Taskmaster ? Register"),
                  ),
                )
              ],
            ),
          )),
        ),
      )),
    );
  }
}
