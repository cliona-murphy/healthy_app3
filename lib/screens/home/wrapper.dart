import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:healthy_app/screens/authentication/authenticate.dart';
import 'package:healthy_app/screens/home/home.dart';
import 'package:provider/provider.dart';
import 'package:healthy_app/models/user.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:healthy_app/models/push_notification.dart';
// import 'package:healthy_app/services/notificationmanager.dart';

class Wrapper extends StatefulWidget {

  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);

    //return either home or authenticate widget
    if (user == null) {
      return Authenticate();
    }
    else {
      // printToConsole();
      return Home();
    }
  }

  String getCurrentDate(){
    var date = new DateTime.now().toString();
    var dateParse = DateTime.parse(date);
    var formattedDate = "${dateParse.day}/${dateParse.month}/${dateParse.year}";
    return formattedDate;
  }
}
