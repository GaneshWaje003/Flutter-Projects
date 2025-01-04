import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class menuPage extends StatefulWidget{
  @override
  State<menuPage> createState() => menuPageState();
}
class menuPageState extends State<menuPage>{

  List<String> navHeading = ['one','two','three','four','five'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Today's Menu",style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Container(
        child: Column(
          children: [
            Container(
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: navHeading.length,
                  itemBuilder: (context,index){
                    return GestureDetector(
                      child: Container(
                        child: Text(navHeading[index]),
                      )
                    );
                  }
              ),
            )


          ],
        ),
      ),
    );
  }

}