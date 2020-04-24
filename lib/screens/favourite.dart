import 'package:binary_test/screens/add_user.dart';
import 'package:binary_test/widget/user_tile.dart';
import 'package:flutter/material.dart';
import '../models/user.dart';
import 'home.dart';
import 'package:flutter/cupertino.dart';

class Favourite extends StatefulWidget {
  List<User> users_favourite = <User>[];
  Favourite({Key key, @required this.users_favourite}) : super(key: key);
 

  @override
  _FavouriteState createState() => _FavouriteState();
  
}

class _FavouriteState extends State<Favourite> {
  List<User> _users = <User>[];

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
          if(segmentedControlValue == 0){
            navigateToHomePage(context);
          }
        });
      },
      groupValue: 1,
    ),
  );
  

  @override
  void initState() {
    super.initState();
    _users = widget.users_favourite;
  }
    

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      centerTitle: true,
      title: Text('Favourites'),
    ),
   body: Container(
        child: Column(
          children: <Widget>[
            _segmentedControl(),
            Expanded(
              child: _users.length > 0
              ? ListView.builder(
                shrinkWrap: true,
                itemCount: _users.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: UserTile(_users[index]),
                  );
                },
              ): Center(child: Text('No Favourites')),
            ),
          ],
          
        ),
      ),

    
  );

  Future navigateToHomePage(BuildContext context) async {
    Navigator.push(context, MaterialPageRoute<void>(builder: (context) => Home()));
  }
}

