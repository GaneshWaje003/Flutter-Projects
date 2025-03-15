import 'package:flutter/material.dart';

class Analytics extends StatefulWidget {
  @override
  State<Analytics> createState() => AnalyticsState();
}

class AnalyticsState extends State<Analytics> {
  List<String> cardsInfo = [
    'Total Count',
    'Total Customer Count',
    'Total Daily Transaction',
    'Today Customers'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Analytics'),
        automaticallyImplyLeading: false,
        centerTitle: false,
        elevation: 5,
      ),
      body: Column(
        children: [

          // Use Expanded to allow GridView to fill remaining space
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 20,
              mainAxisSpacing: 10,
              padding: EdgeInsets.all(40),
              children: List.generate(cardsInfo.length, (index) {
                return Card(
                  elevation: 4, // Optional elevation for shadow effect
                  child: Column(

                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      Container(
                        alignment: Alignment.center,
                        child: Text(
                          cardsInfo[index],
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16),
                        ),
                      ),

                      SizedBox(height: 20,),

                      Container(
                        child: Text('9'),
                      )
                    ],
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
