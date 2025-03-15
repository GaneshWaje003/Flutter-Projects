import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:subscripto/firebaseMethods.dart';

class MenuDialog extends StatefulWidget {
  @override
  State<MenuDialog> createState() => MenuDialogState();
}

class MenuDialogState extends State<MenuDialog> {

  TextEditingController _menuNameController = TextEditingController();
  TextEditingController _menuDescController = TextEditingController();
  TextEditingController _menuPriceController = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  File? _image;

  Future<void> _pickImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    FirebaseMethods firebaseMethods = FirebaseMethods(context: context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("New Menu entry"),
        centerTitle: true,
        titleTextStyle:TextStyle(
          color: Theme.of(context).colorScheme.onPrimary,
          fontSize: 20
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [

            _image != null ?
                Image.file(
                  _image!,
                  width: 200,
                  height: 200,
                  fit:BoxFit.cover
                ):

            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.all(Radius.circular(50))),
              child: ElevatedButton(
                onPressed: _pickImage,
                child: Icon(Icons.add,
                    color: Theme.of(context).colorScheme.onPrimary),
                style: ButtonStyle(
                    backgroundColor:
                        WidgetStatePropertyAll(Theme.of(context).primaryColor)),
              ),
            ),

            SizedBox(height: 50,),

            TextField(
              controller: _menuNameController,
              decoration: InputDecoration(
                labelText: "Enter name",
                border:OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.grey)
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.black)
                ),
                prefixIcon: Icon(Icons.add_circle_outline)
              ),
            ),
            SizedBox(height: 20,),

            TextField(
              controller: _menuDescController,
                decoration: InputDecoration(
                    labelText: "Enter description",
                    border:OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.grey)
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Colors.black)
                    ),
                    prefixIcon: Icon(Icons.description_outlined)
                ),
            ),
            SizedBox(height: 20,),
            TextField(
              controller: _menuPriceController,
              decoration: InputDecoration(
                  labelText: "Enter price",
                  border:OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey)
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)
                  ),
                  prefixIcon: Icon(Icons.currency_rupee)
              ),
            ),

            SizedBox(height: 50,),

            ElevatedButton(
                onPressed: () {
                  String menuName = _menuNameController.text.toString();
                  String menuDesc = _menuDescController.text.toString();
                  String menuPrice = _menuPriceController.text.toString();
                  
                  firebaseMethods.uploadMenuItem(_image!, menuName, menuDesc, menuPrice);

                  _menuNameController.clear();
                  _menuDescController.clear();
                  _menuPriceController.clear();
                  Navigator.pop(context);
                },
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(Theme.of(context).colorScheme.onPrimary),
                  shadowColor: WidgetStatePropertyAll(Colors.grey),
                  padding: WidgetStatePropertyAll(EdgeInsets.symmetric(vertical: 10,horizontal: 30)),
                ),
                child: Text("click" , style: TextStyle(fontSize: 16),)),
          ],
        ),
      ),
    );
  }
}
