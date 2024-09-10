import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:main_app/Login.dart';
import 'package:main_app/services/database.dart';

class Signup extends StatefulWidget {
  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {

  DatabaseMethods db = DatabaseMethods();

  TextEditingController _nameController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

    Color mainThemeColor = Color(0xFF9565f4);

  var _obsecureText = true;

  final _key = GlobalKey<FormState>();

  Future<void> _signUpUser() async{
    if(_key.currentState!.validate()){

      var email =_emailController.text.trim();
      var password =  _passwordController.text.trim();

    var isUserCreated = await db.addUserDetails(email,password);
      if(await isUserCreated){
        _emailController.clear();
        _usernameController.clear();
        _passwordController.clear();
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>Login()));
      }

    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: mainThemeColor,
          child: Column(
        children: [

          Container(
            color: mainThemeColor,
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
                    "Signup",
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                color: Colors.white,
              ),
              child: SingleChildScrollView(
                child: Form(
                  key: _key,
                  child: Column(children: [
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        hintText: "Email",
                        contentPadding: EdgeInsets.symmetric(vertical: 13),
                        prefixIcon: Icon(Icons.email_rounded),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your Email';
                        } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                          return 'Please enter a valid Email';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                        hintText: "Username",
                        contentPadding: EdgeInsets.symmetric(vertical: 13),
                        prefixIcon: Icon(Icons.person_2_rounded),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0)),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your username';
                        } else if (value.length < 3) {
                          return 'Username can\'t be less than 3 chars';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obsecureText,
                      decoration: InputDecoration(
                        hintText: "Password",
                        contentPadding: EdgeInsets.symmetric(vertical: 13),
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
                    SizedBox(height: 30),
                    Container(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                              EdgeInsets.symmetric(vertical: 12)),
                          backgroundColor:
                              MaterialStateProperty.all(mainThemeColor),
                          shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10))),
                        ),
                        onPressed: () {
                          _signUpUser();
                        },
                        child: Text(
                          "Signup",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.only(top: 20), child: Text("Or")),
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            child: Container(
                              padding: EdgeInsets.all(10),
                              decoration: BoxDecoration(color: Colors.white24),
                              child: SvgPicture.asset(
                                'assets/google_logo.svg',
                                height: 50,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          GestureDetector(
                              child: Container(
                            child: SvgPicture.asset(
                              'assets/facebook_logo.svg',
                              height: 57,
                            ),
                          )),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 20),
                      child: TextButton(
                        child: Text("Already registered! Back to login"),
                        onPressed: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Login()));
                        },
                      ),
                    )
                  ]),
                ),
              ),
            ),
          ),

        ],
      )),
    );
  }
}
