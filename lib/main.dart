import 'dart:core';
import 'package:flutter/material.dart';
import 'package:healthy_app/models/arguments.dart';
import 'package:healthy_app/screens/home/home.dart';
import 'package:healthy_app/screens/home/wrapper.dart';
import 'package:healthy_app/services/auth.dart';
import 'package:healthy_app/models/user.dart';
import 'package:provider/provider.dart';
import 'package:healthy_app/shared/globals.dart' as globals;

void main() {
  runApp(myApp());
}
class myApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        theme: ThemeData(
          // Define the default brightness and colors.
          // brightness: Brightness.dark,
          primaryColor: Colors.lightBlue[800],
          accentColor: Colors.cyan[600],
          appBarTheme: AppBarTheme(
            color: Color(0xFF151026),
          ),
          // Define the default font family.
          fontFamily: 'Arial',

          // Define the default TextTheme. Use this to specify the default
          // text styling for headlines, titles, bodies of text, and more.
          textTheme: TextTheme(
            headline1: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
            headline6: TextStyle(fontSize: 20.0, fontStyle: FontStyle.italic),
            bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
          ),
        ),
        debugShowCheckedModeBanner: false,
           initialRoute: '/',
           routes: {
            '/second': (context) => Home(),
           },
           home: Wrapper(),
      ),
    );
  }
}

