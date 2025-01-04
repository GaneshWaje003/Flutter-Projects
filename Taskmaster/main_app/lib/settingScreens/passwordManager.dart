import 'package:flutter/material.dart';

class PasswordManager extends StatefulWidget {
  @override
  State<PasswordManager> createState() => _PasswordManagerState();
}

class _PasswordManagerState extends State<PasswordManager> {
  @override
  Widget build(BuildContext context) {

    int _itemCount = 7;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        automaticallyImplyLeading: false,
        title: Text(
          "password Manager",
          style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),
        ),
      ),

      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        height: double.infinity,
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(Icons.search_rounded),
                suffixIcon: Icon(Icons.mic),
                filled: true,
                fillColor: Colors.blue[100],
                hintText: 'Enter search term',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20))
                )
              ),
            ),

            Expanded(
                child:ListView.builder(
                    itemCount: _itemCount,
                    itemBuilder: (context,index){
                        return ListTile(
                          title: Text('abc'),
                        );
                    }
                )
            )
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add , color: Theme.of(context).colorScheme.onPrimary,),
          onPressed: () {}),
    );

  }
}
