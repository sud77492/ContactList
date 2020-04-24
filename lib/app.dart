import 'package:flutter/material.dart';
import 'screens/home.dart';

class ContactListApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Contact List App',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primaryColor: Colors.black,
      accentColor: Colors.black
    ),
    home: Home(),
  );
}
