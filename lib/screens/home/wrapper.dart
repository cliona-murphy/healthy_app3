import 'package:flutter/material.dart';
import 'package:healthy_app/screens/authentication/authenticate.dart';
import 'package:healthy_app/screens/home/home.dart';
import 'package:provider/provider.dart';
import 'package:healthy_app/models/user.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);
    print(user);

    //return either home or authenticate widget
    if (user == null) {
      return Authenticate();
    }
    else {
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
