library healthy_app.globals;

import 'package:cupertino_setting_control/cupertino_setting_control.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

bool newDateSelected = false;
String selectedDate = getCurrentDate();
int kcalIntakeTarget = 2000;
int kcalOutputTarget = 2000;
int waterIntakeTarget = 0;
DateTime newDate = new DateTime.now();
bool settingsChanged = false;
String selectedTime = "";
TextStyle foodDiary = TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold, color: Color.fromRGBO(157, 131, 212, 1.0));
Color lightPurple = Color.fromRGBO(157, 131, 212, 1.0);
Color darkPurple =  Color(0xFF151026);
BoxDecoration foodDiaryBox = BoxDecoration(border: Border.all(color: Color.fromRGBO(157, 131, 212, 1.0), width: 2.0));
TextStyle settingsHeading = TextStyle(
  color: Color.fromRGBO(157, 131, 212, 1.0),
  fontSize: 20.0,
  fontWeight: FontWeight.bold,
);
SettingsRowStyle settingsStyle = SettingsRowStyle(
  activeColor: darkPurple,
  fontSize: 20,
);

String getCurrentDate() {
  var date = new DateTime.now().toString();
  var dateParse = DateTime.parse(date);
  var formattedDate = "${dateParse.day}/${dateParse.month}/${dateParse.year}";
  return formattedDate;
}

showSnackBar(BuildContext context, String title, String message){
  return Flushbar(
    duration: Duration(seconds: 2),
    flushbarPosition: FlushbarPosition.TOP,
    title: title,
    message: message,
  )..show(context);
}
