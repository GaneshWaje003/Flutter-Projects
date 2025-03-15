  import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';

class AddUser extends StatefulWidget{
  @override
  State<AddUser> createState()=>AddUserState();
}

class AddUserState extends State<AddUser> {

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  int _selectedIndex = 1;
  String _qrCodeResult = "";


  @override
  Widget build(BuildContext context) {

    List<Widget> _contentList =[
    // Center(child:QRView(key: qrKey,
    // onQRViewCreated: _onQrViewCreated,) ),
    Center(child: QrImageView(data: '1234345',version: QrVersions.auto,size: 250.0,)),
  ];

    return Scaffold(
      appBar: AppBar(
        title: Text('add user',style: TextStyle(color: Theme.of(context).colorScheme.onPrimary),),
        backgroundColor: Theme.of(context).colorScheme.primary,
        automaticallyImplyLeading: false,
      ),

      body:Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget> [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                  onTap: (){
                    setState(() {
                      _selectedIndex = 0;
                    });
                  },
                  child: Icon(Icons.qr_code_scanner , size: 40,color: _selectedIndex == 0 ? Colors.black:Colors.grey,)),
              SizedBox(width: 100,),
              GestureDetector(
                  onTap: (){
                    setState(() {
                      _selectedIndex = 1;
                    });
                  },
                  child: Icon(Icons.qr_code , size: 40,color: _selectedIndex == 1 ? Colors.black:Colors.grey,)),


            ],
          ),

          IndexedStack(
            index: _selectedIndex,
            children: _contentList,
          ),
        ],
      ),
      
      floatingActionButton: FloatingActionButton(onPressed: (){},child: Icon(Icons.add),),
    );
  }

}