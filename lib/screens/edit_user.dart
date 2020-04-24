import 'package:flutter/material.dart';
import 'package:gender_selection/gender_selection.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'home.dart';
import '../models/user.dart';
import 'package:flutter/cupertino.dart';

class EditUser extends StatefulWidget {
  final User user;

  EditUser({Key key, this.user}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  
  @override
  _EditUserState createState() => _EditUserState();
}

class _EditUserState extends State<EditUser> {

  TextEditingController firstNameController = new TextEditingController();
  TextEditingController lastNameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController phoneController = new TextEditingController();
  TextEditingController dobController = new TextEditingController();
  String genderValue;
  String time;
  

  //var finaldate;

  void callDatePicker() async {
    var order = await getDate();
    setState(() {
      dobController.text = order.toString();
      time = order.microsecondsSinceEpoch.toString();
      print(order);
      //finaldate = order;
    });
  }

  Future<DateTime> getDate() {
    // Imagine that this function is
    // more complex and slow.
    return showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1970),
      lastDate: DateTime(3000),
      builder: (BuildContext context, Widget child) {
        return Theme(
          data: ThemeData.light(),
          child: child,
        );
      },
    );
  }

   @override
  void initState() {
    super.initState();
    firstNameController.text = widget.user.first_name;
    lastNameController.text = widget.user.last_name;
    emailController.text = widget.user.email;
    phoneController.text = widget.user.phone_no;
    dobController.text = time;
    genderValue = widget.user.gender;
    //var date = new DateTime.fromMillisecondsSinceEpoch(int.parse(widget.user.date_of_birth) * 1000);
    
    //time = date.toString();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    
    
    
    //print(date);

    final firstNameField = TextField(
      controller: firstNameController,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "First Name",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );
    
    final lastNameField = TextField(
      controller: lastNameController,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Last Name",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );
    final phoneField = TextField(
      controller: phoneController,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Phone Number",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    final emailField = TextField(
      controller: emailController,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Email",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    final dobField = TextField(
      controller: dobController,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Date of birth",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
          onTap: (){
            callDatePicker();
          },
    );
 
    final genderField = GenderSelection(
        maleText: "Male", //default Male
        femaleText: "Female", //default Female
        selectedGenderIconBackgroundColor: Colors.indigo, // default red 
        checkIconAlignment: Alignment.centerRight,   // default bottomRight
        selectedGenderCheckIcon: Icons.check, // default Icons.check
        onChanged: (Gender gender){
          switch(gender.index){
            case 0:
              genderValue = "Male";
            break;
            case 1:
              genderValue = "Female";
            break;
          }
        },
        maleImage: AssetImage("assets/images/boy.png"),
        femaleImage: AssetImage("assets/images/girl.png"),
        equallyAligned: true,
        animationDuration: Duration(milliseconds: 400),
        isCircular: true, // default : true,
        isSelectedGenderIconCircular: true,
        opacityOfGradient: 0.6,
        padding: const EdgeInsets.all(3),
        size: 120, //default : 120

    );

    final loginButon = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Color(0xff01A0C7),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          print(firstNameController.text);
          Map<String, String> body = {
            "id": widget.user.id,
            "first_name": firstNameController.text,
            "last_name": lastNameController.text,
            "email": emailController.text,
            "gender": genderValue,
            "date_of_birth": time,
            "phone_no": phoneController.text
          };
          editUserToServer('https://mock-rest-api-server.herokuapp.com/api/v1/user/'+widget.user.id, body);

          //await Provider.of<AuthProvider>(context).apiRequest(widget.name, widget.mobile, widget.response_id, widget.response, rating.toString(), textFieldController.text, "sfdnfads", "A50s");

        },
        child: Text("Update",
          textAlign: TextAlign.center
        )
      ),
    );

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Edit User'),
      ),
      body: SingleChildScrollView(
      child: Center(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(36.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 155.0,
                  child: Image.asset(
                    "assets/images/user.jpg",
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: 45.0),
                firstNameField,
                SizedBox(height: 25.0),
                lastNameField,
                SizedBox(height: 25.0),
                emailField,
                SizedBox(height: 25.0),
                phoneField,
                SizedBox(height: 25.0),
                dobField,
                SizedBox(height: 25.0),
                genderField,
                SizedBox(
                  height: 35.0,
                ),
                loginButon,
                SizedBox(
                  height: 15.0,
                ),
              ],
            ),
          ),
        ),
      ),
      )
    );
  }

  Future<bool> editUserToServer(String url, Map jsonMap) async {
    //encode Map to JSON
    print(url);
    print(json.encode(jsonMap));
    final response = await http.put(url, headers: {"Content-Type": "application/json"}, body: json.encode(jsonMap));
    Map<String, dynamic> apiResponse = json.decode(utf8.decode(response.bodyBytes));
    print(apiResponse.toString());
    if (response.statusCode == 200) {
      Map<String, dynamic> apiResponse = json.decode(utf8.decode(response.bodyBytes));
      print(apiResponse.toString());
      navigateToSubPage(context);
      return true;
    }
    if (response.statusCode == 401) {
      return false;
    }
    return false;
  }

  Future<String> apiRequest(String url, Map jsonMap) async {
    print("DATA : " + json.encode(jsonMap).toString());
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.postUrl(Uri.parse(url));
    request.headers.set('content-type', 'application/json');
    request.add(utf8.encode(json.encode(jsonMap)));
    
    HttpClientResponse response = await request.close();
    print(json.decode(request.toString()));
    // todo - you should check the response.statusCode
    String reply = await response.transform(utf8.decoder).join();
    //print(reply);
    httpClient.close();
    return reply;
  }

  Future navigateToSubPage(BuildContext context) async {
    Navigator.push(context, MaterialPageRoute<void>(builder: (context) => Home()));
  }
}