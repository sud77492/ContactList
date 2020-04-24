import 'package:binary_test/screens/add_user.dart';
import 'package:binary_test/screens/favourite.dart';
import 'package:binary_test/widget/user_tile.dart';
import 'package:flutter/material.dart';
import '../models/user.dart';
import 'add_user.dart';
import 'edit_user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
  
}

class _HomeState extends State<Home> {
  bool _saving = false;
  List<User> _users = <User>[];
  List<User> _search_users = <User>[];
  List<User> favourite_user = <User>[];
  

  int segmentedControlValue = 0;
  Widget _segmentedControl() => Container(
    width: 500,
    child: CupertinoSegmentedControl<int>(
      padding: const EdgeInsets.all(8.0),
      selectedColor: Colors.blue,
      borderColor: Colors.white,
      children: {
        0: Text('All'),
        1: Text('Favourites'),
      },
      onValueChanged: (int val) {
        setState(() {
          segmentedControlValue = val;
          if(segmentedControlValue == 1){
            navigateToFavouritePage(context);
          }
        });
      },
      groupValue: 0,
    ),
  );
  

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  void filterSearchResults(String query) {
    List<User> localSearchList = <User>[];
    localSearchList.addAll(_search_users);
    if(query.isNotEmpty) {
      List<User> localListData = <User>[];
      localSearchList.forEach((item) {
        print(query);
        print(item.first_name);
        if(item.first_name.toLowerCase().contains(query.toLowerCase()) || item.last_name.toLowerCase().contains(query.toLowerCase()) ||
        item.phone_no.contains(query)){
          localListData.add(item);
        }
      });
      setState((){
        _users.clear();
        _users.addAll(localListData);
      });
      return;
    } else {
      setState(() {
        _users.clear();
        _users.addAll(_search_users);
      });
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      centerTitle: true,
      title: Text('Contacts'),
    ),
   body: ModalProgressHUD(child: Container(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                onChanged: (value) {
                  filterSearchResults(value);
                },
                decoration: InputDecoration(
                    labelText: "Search",
                    hintText: "Search",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(25.0)))),
              ),
            ),
            _segmentedControl(),
            Expanded(
              child: _users.length > 0
              ? ListView.builder(
                  itemCount: _users.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Dismissible(
                      onDismissed: (DismissDirection direction) {
                        setState(() {
                          print(direction.index);
                          if(direction.index == 2)
                            deleteUser('https://mock-rest-api-server.herokuapp.com/api/v1/user/'+_users[index].id);
                          else
                            navigateToEditUserPage(context, index);
                        });
                      },
                      background: Container(
                        child: Icon(Icons.edit),
                        color: Colors.green,
                        alignment: Alignment.centerLeft,
                      ),
                      secondaryBackground: Container(
                        child: Icon(Icons.delete),
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                      ),
                      child: ListTile(
                        title: UserTile(_users[index]),
                        onTap: (){
                          if(favourite_user.length > 0){
                            int count = 0;
                            for(int j = 0; j < favourite_user.length; j++){
                              print(_users[index].id);
                              print(favourite_user[j].id);
                              if(_users[index].id == favourite_user[j].id){
                                favourite_user.remove(_users[index]);
                                count = 1;
                                break;
                              }
                            }
                            if(count == 0){
                              favourite_user.add(_users[index]);
                            }
                          }else{
                            favourite_user.add(_users[index]);
                          }
                          
                        },
                      ),
                      key: UniqueKey(),
                      //direction: DismissDirection.endToStart,
                    );
                  },
                )
              : Center(child: Text('No Items')),
            )
          ],

        ),
      ),
      inAsyncCall: _saving),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () { 
          navigateToAddUserPage(context);
        },
      ),
    
  );

  Future navigateToAddUserPage(BuildContext context) async {
    Navigator.push(context, MaterialPageRoute<void>(builder: (context) => AddUser()));
  }

  Future navigateToEditUserPage(BuildContext context, int index) async {
    Navigator.push(context, MaterialPageRoute<void>(builder: (context) => EditUser(user: _users[index])));
  }

  Future navigateToFavouritePage(BuildContext context) async {
    print(_search_users.length);
    Navigator.push(context, MaterialPageRoute<void>(builder: (context) => Favourite(users_favourite : favourite_user)));
  }


  void _fetchData() async {
      setState(() {
        _saving = true;
      });
      final response = await http.get("https://mock-rest-api-server.herokuapp.com/api/v1/user?page=2&row=40",headers: {
              'Accept': 'application/json'});
      
      if (response.statusCode == 200) {
        Map<String, dynamic> apiResponse = json.decode(utf8.decode(response.bodyBytes));
        setState(() {
          _saving = false;
          _users = (apiResponse['data'] as List)
          .map((data) => new User.fromJson (data))
          .toList();
          _search_users = (apiResponse['data'] as List)
          .map((data) => new User.fromJson (data))
          .toList();
        });
        
        //print(apiResponse['questions'][0]['options'][0]['option_english']);
        // setState(() {
          
        // });
      } else {
        throw Exception('Failed to load photos');
      }
      

      //Simulate a service call
      print('submitting to backend...');
      
    }

  Future<bool> deleteUser(String url) async {
    print(url);
    final response = await http.delete(url, headers: {"Content-Type": "application/json"});
    Map<String, dynamic> apiResponse = json.decode(utf8.decode(response.bodyBytes));
        print(apiResponse.toString());
    if (response.statusCode == 200) {
      setState(() {
        Map<String, dynamic> apiResponse = json.decode(utf8.decode(response.bodyBytes));
        print(apiResponse.toString());
        _fetchData();
        //navigateToSubPage(context);
        return true;
      });
      
    }
    
    if (response.statusCode == 401) {
      return false;
    }
    return false;
  }

}

