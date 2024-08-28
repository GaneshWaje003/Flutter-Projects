import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Language extends StatefulWidget {
  @override
  State<Language> createState() => _LanguageState();
}


class _LanguageState extends State<Language> {


  Color whiteBack = Color(0xFFF2F2F2);
  var currLang,currItem,currFunc;
  var currSelcted;
  late List<String> LangArray;

  @override
  void initState() {
    super.initState();
    // Initialize LangArray in initState
    LangArray = [
      'English',
      'Marathi',
      'Hindi',
      'German' ,
      'French',
      'Kannad'
    ];
  }

  void changeLang(var index){
    setState(() {
      currSelcted = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Languages"),
          automaticallyImplyLeading: false,
          elevation: 1.0,
        ),
        body: Container(
          color: Color.fromRGBO(242, 242, 242, 255),
          margin: EdgeInsets.symmetric(vertical: 10.0),
          child: ListView.builder(
              itemCount: LangArray.length,
              itemBuilder: (context, index) {
                currItem = LangArray[index];
                currLang = currItem;
                return Container(
                  decoration: BoxDecoration(
                      border: Border(bottom: BorderSide(color: Colors.black12, width: 1.0))
                  ),

                  child: ListTile(
                    title: Text(currLang),
                    onTap:() {
                print("Tapped on $index");
                    changeLang(index);
                },
                    trailing: currSelcted == index ? Icon(Icons.check,color: Colors.blue,):null,
                  ),
                );
              }),
        ));
  }
}
