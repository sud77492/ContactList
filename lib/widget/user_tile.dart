import 'package:flutter/material.dart';
import '../models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserTile extends StatelessWidget {
  final User _user;
  SharedPreferences prefs;
  List<User> listFilter;
  UserTile(this._user);
  List<String> listId;

  @override
  Widget build(BuildContext context) => Column(
    children: <Widget>[
      ListTile(
        title: Text(_user.first_name),
        subtitle: Text(_user.phone_no),
        leading: Container(
           //margin: EdgeInsets.only(left: 6.0),
           child: Image.asset('assets/images/user.jpg')
        ),
        trailing: Container(
          child: IconButton(
            icon: new Icon(Icons.star),
            //onPressed: () { 
              //User user = User(_user.id, _user.first_name, _user.last_name, _user.email, _user.gender, _user.date_of_birth, _user.phone_no);
              //listFilter.add(user);
              //listId.add(_user.id);
              //print(listId[0]);
              //print(listId.length);
              //print(_user.id);
              //listId.add(_user.id.toString());
              //_showToast(context);
            //},
          ),

        ),
      ),
      Divider()
    ],
  );

  void _showToast(BuildContext context) {
    final scaffold = Scaffold.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: const Text('Added to favorite'),
        action: SnackBarAction(
            label: '', onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }
}
