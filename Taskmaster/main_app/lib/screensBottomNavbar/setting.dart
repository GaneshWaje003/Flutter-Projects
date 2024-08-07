import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:main_app/Login.dart';
import 'package:main_app/settingScreens/language.dart';

class Setting extends StatefulWidget {
  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  LinearGradient myGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Colors.lightBlue, Colors.blue]);

  Color mainSettingColor = Color.fromRGBO(50, 50, 150, 0.1);

    // List<void Function()> functionForList = [themeFunc,languageFunc,aboutFunc,contactFunc,logoutFunc];

  List<List<dynamic>> listData = [
    [Icons.sunny,'Theme',()=>print('hello theme')],
    [Icons.language,'Language',(context)=> Navigator.push(context,MaterialPageRoute(builder: (context)=>Login())   ) ],
    [Icons.account_circle_sharp,'About',()=>print('hello theme')],
    [Icons.phone_rounded,'Contact',()=>print('hello theme')],
    [Icons.logout,'Logout',()=>print('hello theme')]
  ];

  var changeTheme = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Setting", style: TextStyle(fontSize: 25)),
      ),
      body: Container(
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
                    margin: EdgeInsets.only(right: 20,bottom: 20),
                    width: double.infinity,
                    height: 150,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: mainSettingColor),
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 10),
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.asset(
                              'assets/ronaldo_potrait.jpeg',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),

                        Container(
                          margin:EdgeInsets.only(left: 40),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: Text("Username",style:TextStyle(fontSize: 16)),
                              ),

                              Container(
                                margin: EdgeInsets.only(top: 20),
                                child: Text("Email123@gmail.com",style:TextStyle(fontSize: 16)),
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
                        trailing: index == 0 ? Switch(
                          value: changeTheme,
                          onChanged:(bool value) {
                            setState(() {
                              changeTheme = ! changeTheme;
                            });
                          },
                          thumbIcon: WidgetStateProperty
                              .resolveWith<Icon?>(
                                (Set<WidgetState> states) {
                              if (states
                                  .contains(WidgetState.selected)) {
                                return Icon(Icons.dark_mode);
                              }
                              return Icon(Icons.light_mode,color: Colors.white,);
                            },
                          ),
                          activeTrackColor:Theme.of(context).cardColor,
                          inactiveTrackColor: Colors.white38,

                        ) : Icon(Icons.chevron_right),

                        onTap:itemFunctions ,
                      ),
                    );
                  }),
            ),

            Container(
              child:Text('Taskmaster : 1.0',style: TextStyle(fontSize: 12,color: Colors.grey),),
              margin: EdgeInsets.only(bottom: 20),
            ),
          ],
        ),
      ),
    );
  }
}
