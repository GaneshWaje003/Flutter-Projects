import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:subscripto/firebaseMethods.dart';
import 'package:subscripto/inputDialogs/menuDilaog.dart';

class menuPage extends StatefulWidget{
  @override
  State<menuPage> createState() => MenuPageState();
}
class MenuPageState extends State<menuPage>{

  bool _isCheckboxMode = false; // for toggling the selection of items
  bool _isAllSelected = false;
  List<String> menuItemIdList=[];
  List<String> menuList =[];
  List<bool> _selectedListItems = [];

  TextStyle titleStyle = TextStyle(
    fontSize: 14, color: Colors.red,
  );TextStyle subStyle = TextStyle(
  );

  void selectAllActivity(){
    setState(() {
      bool allSelected = _selectedListItems.every((selected)=>selected);
      _selectedListItems = List.generate(_selectedListItems.length,(index)=>!allSelected);
      allSelected ?  _isAllSelected = true : _isAllSelected = false;
     });
  }

  void toggleCheckboxMode(){
    setState(() {
      _isCheckboxMode = !_isCheckboxMode;
    });
  }

  Future<bool> onWillPop() async{
    if(_isCheckboxMode){
      setState(() {
        _selectedListItems.fillRange(0, _selectedListItems.length,false);
        _isCheckboxMode = false;
      });
      return false ;
    }
    return true;
  }


  @override
  Widget build(BuildContext context) {

    FirebaseMethods firebaseMethods = FirebaseMethods(context: context);
    Color onPrimaryColor = Theme.of(context).colorScheme.onPrimary;
    Color primaryColor = Theme.of(context).colorScheme.primary;

    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("Today's Menu",style: TextStyle(color: onPrimaryColor),),
          backgroundColor: primaryColor,
          actions: [
            _isCheckboxMode ? Text('(${_selectedListItems.where((item)=> item == true).length})',style: TextStyle(color: onPrimaryColor , fontSize: 18),) : Text(''),
             IconButton(onPressed: ()=>toggleCheckboxMode(), icon: Icon(Icons.check_box_rounded , color: _isCheckboxMode ? onPrimaryColor  : Colors.white38)),
            _isCheckboxMode ? Row(
              children: [
                IconButton(onPressed: ()=>selectAllActivity(), icon: Icon(Icons.select_all , color: onPrimaryColor,)),
                IconButton(onPressed: (){
                  List<String> itemsToDelete = [];
                  for (int i = 0; i < _selectedListItems.length; i++) {
                    if (_selectedListItems[i]) {
                      itemsToDelete.add(menuItemIdList[i]);
                    }
                  }
                  firebaseMethods.deleteInfo(itemsToDelete);

                  setState(() {
                    _selectedListItems.fillRange(0, _selectedListItems.length , false);
                    _isCheckboxMode = false;
                  });

                }, icon: Icon(Icons.delete_forever , color:  onPrimaryColor,)),
              ],
            ) : Container(),
          ],
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance.collection('menuItem').snapshots(),
            builder: (context,snapshots) {
                if(snapshots.connectionState == ConnectionState.waiting){
                  return Center(child: CircularProgressIndicator());
                }
                if(!snapshots.hasData || snapshots.data!.docs.isEmpty){
                  return Center(child:Text("No Data Found"));
                }

                var data = snapshots.data!.docs;
                menuList = data.map((item) => item['name'].toString()).toList();
                menuItemIdList = data.map((item)=>item.id).toList();

                if(_selectedListItems.length < menuList.length){
                  _selectedListItems = List.generate(menuList.length,(index)=>false);
                }

                return Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                          itemCount: data.length,
                          itemBuilder: (context,index){
                            var item = data[index].data() as Map<String,dynamic>;
                            return Container(
                              margin: EdgeInsets.symmetric(horizontal: 10,vertical: 2),
                              child: Row(
                                children: [
                                  _isCheckboxMode ?
                                      Checkbox(
                                          value:_selectedListItems[index],
                                          onChanged: (bool? value){
                                            setState(() {
                                              _selectedListItems[index] = value ?? false;
                                            });
                                            print('state updated ${value}');
                                      }) : Container(),

                                  Expanded(
                                    child: Card(
                                      child: ListTile(
                                        title: Text(item['name']),
                                        titleTextStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.black , fontSize: 15),
                                        subtitle: Text(item['desc']),
                                        subtitleTextStyle: TextStyle(color: Colors.grey , fontSize: 13),
                                        leading: Icon(Icons.label_important_rounded),
                                        contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                                        tileColor: Color(0xFFefefff),
                                        shape: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),
                                          borderSide: BorderSide(width: 0,color: Colors.transparent)
                                        ),
                                        onLongPress: (){
                                          setState(() {
                                            if(_isCheckboxMode){
                                              _isCheckboxMode = false;
                                            }else{
                                            _isCheckboxMode = true;
                                            }
                                          });
                                        },
                                        onTap: (){
                                            // if(_isCheckboxMode){
                                            //   if(_selectedListItems[index]){
                                            //     _selectedListItems[index] = false;
                                            //   }else{
                                            //     _selectedListItems[index] = true;
                                            //   }
                                            // }
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            );
                          }
                      ),
                    ),
                  ],
                );
            },
        ),

        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: (){
                // Navigator.pushNamed(context, 'addMenuItemDialog');
              Navigator.push(context,MaterialPageRoute(builder: (context)=>MenuDialog()));
            }),
      ),
    );
  }

}