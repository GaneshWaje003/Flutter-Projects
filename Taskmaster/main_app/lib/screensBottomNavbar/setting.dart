import 'package:flutter/material.dart';
import 'package:main_app/Login.dart';
import 'package:main_app/services/database.dart';
import 'package:main_app/settingScreens/aobut.dart';
import 'package:main_app/settingScreens/language.dart';
import 'package:main_app/settingScreens/passwordManager.dart';

class Setting extends StatefulWidget {

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {

  DatabaseMethods db = DatabaseMethods();

  void logOutuser(context) async {
    var isLoggedOut = await db.logOut();
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => Login()));
  }

  Color mainSettingColor = Color.fromRGBO(50, 50, 150, 0.1);
  var changeTheme = false;
  late UserDataModel obj;
  var username = 'username';
  var userEmail = '';
  var userPhotourl = '';

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  void _fetchUserData() async {
    try {
      Map<String, dynamic> data = await db.getUserData();
      setState(() {
        username = data['userName'];
        userEmail = data['userEmail'] ;
        userPhotourl = data['userPhotourl'];
      });
    } catch (e) {
      print('error setting $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    List<List<dynamic>> listData = [
      [Icons.sunny, 'Theme', () => print('hello theme')],
      [
        Icons.language,
        'Language',
        (context) => Navigator.push(
            context, MaterialPageRoute(builder: (context) => Language())),
      ],
      [
        Icons.account_circle_sharp,
        'About',
        (context) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => About()));
        }
      ],
      [Icons.phone_rounded, 'Contact', () => print('hello theme')],
      [Icons.lock_rounded, 'password Manager', (context) {
        Navigator.push(
            context,MaterialPageRoute(builder: (context)=>PasswordManager()));
        }
        ],
      [Icons.logout, 'Logout', (context) => logOutuser(context)]
    ];

    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.only(left: 20),
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Container(
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      margin: EdgeInsets.only(right: 20, bottom: 20),
                      width: double.infinity,
                      height: 150,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          color: Theme.of(context).colorScheme.tertiary
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.all(Radius.circular(50)),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child:
                                  userPhotourl != null && userPhotourl.isNotEmpty
                                      ? Image.network(
                                          userPhotourl,
                                          fit: BoxFit.cover,
                                        )
                                      : Image.asset(
                                          'assets/defaultUserImage.png',
                                          fit: BoxFit.cover,
                                        ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(left: 40),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Text(
                                      username.length > 20
                                          ? '${username.substring(0,20)} ...'
                                          :  username ,
                                      style: TextStyle(fontSize: 20,color: Colors.black,fontWeight: FontWeight.bold)),
                                ),
                                Container(
                                  margin: EdgeInsets.only(top: 10),
                                  child: Text(
                                      userEmail.length > 20
                                          ? '${userEmail.substring(0, 20)}...'
                                          : userEmail,
                                      style: TextStyle(fontSize: 16)),
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                    itemCount: listData.length,
                    itemBuilder: (context, index) {
                      final item = listData[index];
                      final itemLeading = item[0];
                      final itemName = item[1];
                      final itemFunctions = item[2];
        
                      return Container(
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(color: Colors.black12))),
                        child: ListTile(
                            title: Text(
                              itemName,
                              style: TextStyle(fontSize: 16),
                            ),
                            leading: Icon(itemLeading),
                            trailing: index == 0
                                ? Switch(
                                    value: changeTheme,
                                    onChanged: (bool value) {
                                      setState(() {
                                        changeTheme = !changeTheme;
                                      });
                                    },
                                    thumbIcon:
                                        WidgetStateProperty.resolveWith<Icon?>(
                                      (Set<WidgetState> states) {
                                        if (states
                                            .contains(WidgetState.selected)) {
                                          return Icon(Icons.dark_mode,color: Theme.of(context).colorScheme.primary,);
                                        }
                                        return Icon(
                                          Icons.light_mode,
                                        );
                                      },
                                    ),
                              activeColor: Colors.white,
                                inactiveTrackColor: Theme.of(context).colorScheme.tertiary,
                              activeTrackColor: Theme.of(context).colorScheme.primary,
                                  )
                                : Icon(Icons.chevron_right),
                            onTap: () => itemFunctions(context)),
                      );
                    }),
              ),
              Container(
                child: Text(
                  'Taskmaster : 1.0',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                margin: EdgeInsets.only(bottom: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UserDataModel {
  final String? username;
  final String? userEmail;
  final String? userPhotourl;

  UserDataModel(
      {required this.username,
      required this.userEmail,
      required this.userPhotourl});

  UserDataModel.empty()
      : username = null,
        userEmail = null,
        userPhotourl = null;
}
