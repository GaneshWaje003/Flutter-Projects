import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:main_app/mainPage.dart';
import 'package:main_app/services/database.dart';
import 'package:main_app/signup.dart';

class Login extends StatefulWidget {
  @override
  State<Login> createState() => _loginstate();
}

class _loginstate extends State<Login> {
  Color MainThemeColor = Color(0xFF9565f4);

  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  final _key =
      GlobalKey<FormState>(); // for authentication of the textformfield

  bool _obsecureText = true;

  DatabaseMethods db = DatabaseMethods();

  Future<void> loginUser() async {
    if (_key.currentState!.validate()) {
      // If the form is valid, proceed with the login logic
      var username = _usernameController.text.trim();
      var pass =  _passwordController.text.trim();

      var isUserCreated = await db.loginUser(username,pass);
      if (isUserCreated == "Login successful") {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Mainpage()));
        _usernameController.clear();
        _passwordController.clear();
      }

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
      backgroundColor: Theme.of(context).cardColor,
      body: Container(
          child: Column(
        children: [
          Container(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.only(top: 15),
                  child: Lottie.asset('animations/signup.json',
                      repeat: true, width: double.infinity, height: 200),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 20),
                  child: Text(
                    "Login",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: Container(
              // padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                color: Colors.white,
              ),

              child: SingleChildScrollView(
                child: Form(
                    child: Column(
                  children: [
                    // container for textss
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(bottom: 5),
                            padding: EdgeInsets.symmetric(horizontal: 30),
                            child: Align(
                              child: Text("Welcome 😊",
                                  style: TextStyle(fontSize: 25)),
                              alignment: Alignment.topLeft,
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 30),
                            child: Align(
                              child: Text(
                                  "Fill correct data for succesful login",
                                  style: TextStyle(fontSize: 16)),
                              alignment: Alignment.topLeft,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(bottom: 30),
                            padding: EdgeInsets.symmetric(horizontal: 30),
                            child: Align(
                              child: Text(
                                  "and taskmaster will arrange your day",
                                  style: TextStyle(fontSize: 16)),
                              alignment: Alignment.topLeft,
                            ),
                          ),
                        ],
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
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 15),
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
                              obscureText: _obsecureText,
                              decoration: InputDecoration(
                                hintText: "Password",
                                contentPadding:
                                    EdgeInsets.symmetric(vertical: 15),
                                prefixIcon: Icon(Icons.lock),
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      _obsecureText = !_obsecureText;
                                    });
                                  },
                                  icon: Icon(_obsecureText
                                      ? Icons.remove_red_eye
                                      : Icons.remove_red_eye_outlined),
                                ),
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
                            ),
                            Container(
                              width: double.infinity,
                              margin: EdgeInsets.symmetric(vertical: 50),
                              child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Theme.of(context).cardColor),
                                    padding: MaterialStateProperty.all(
                                        EdgeInsets.symmetric(vertical: 10)),
                                    shape: MaterialStateProperty.all(
                                        RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10))),
                                  ),
                                  onPressed: () {
                                    loginUser();
                                  },
                                  child: Text(
                                    "Login",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  )),
                            ),
                            Container(
                                child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Signup()));
                              },
                              child: Text("New to Taskmaster ? Register",style:TextStyle(color:Colors.blue)),
                            )),
                          ],
                        ),
                      ),
                    ),
                  ],
                )),
              ),
            ),
          )
        ],
      )),
    );
  }
}
