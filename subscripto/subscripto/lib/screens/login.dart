import 'package:flutter/material.dart';
import 'package:subscripto/appText.dart';
import 'package:subscripto/firebaseMethods.dart';

class Login extends StatefulWidget {
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController _loginEmailController = TextEditingController();
  TextEditingController _loginPasswordController = TextEditingController();


  bool showPassword = true;
  Icon eyeIcon = Icon(Icons.remove_red_eye);

  @override
  Widget build(BuildContext context) {

    FirebaseMethods firebaseMethods = FirebaseMethods(context: context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 24),
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: _loginEmailController,
              decoration: InputDecoration(
                labelText: 'Enter Email',
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                prefixIcon: Icon(Icons.email_rounded),
              ),
            ),

            SizedBox(
              height: 50,
            ),

            TextFormField(
              controller: _loginPasswordController,
              obscureText: showPassword,
              decoration: InputDecoration(
                labelText: 'Enter password',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                prefixIcon: Icon(Icons.lock),
                suffixIcon: IconButton(
                    onPressed: (){
                        if(showPassword){
                          setState(() {
                            eyeIcon = Icon(Icons.remove_red_eye_outlined);
                            showPassword = false;
                          });
                        }else{
                          setState(() {
                            eyeIcon = Icon(Icons.remove_red_eye);
                            showPassword = true;
                          });
                        }
                    },
                    icon: eyeIcon,
              ),
            ),
            ),

            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                  onPressed: () {},
                  child: Text(
                    'forgot password',
                    style: TextStyle(color: Colors.blue),
                  )),
            ),

            SizedBox(height: 50),

            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(
                    Theme.of(context).colorScheme.primary),
                padding: WidgetStatePropertyAll(
                    EdgeInsets.symmetric(horizontal: 50, vertical: 10)),
              ),
              child: Text(
                AppText.loginBtnText,
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontSize: 18),
              ),

              onPressed: () {
                String email = _loginEmailController.text.toString();
                String password = _loginPasswordController.text.toString();

                if(email.isNotEmpty && password.isNotEmpty){
                  firebaseMethods.loginUserWithEmail(email, password);
                  _loginEmailController.clear();
                  _loginPasswordController.clear();
                }
              },
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Dont have account ?' ,style: TextStyle(color: Colors.deepPurple),),
                TextButton(onPressed: (){
                  Navigator.pushNamed(context, '/signup');
                }, child: Text('create account ' ,style: TextStyle(color: Colors.deepPurple),))
              ],
            )

          ],
        ),
      ),
    );
  }
}
