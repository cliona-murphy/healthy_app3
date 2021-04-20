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
          debugShowCheckedModeBanner: false,
           initialRoute: '/',
           routes: {
            '/second': (context) => Home(),
           },
          // home: Wrapper(),
        home: Home(),
      ),
    );
  }
}

