import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:healthy_app/models/arguments.dart';
import 'package:healthy_app/services/database.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:healthy_app/screens/home/home.dart' as HomePage;
import 'package:healthy_app/shared/globals.dart' as globals;
import 'package:provider/provider.dart';

class CalendarView extends StatefulWidget {

  final String title;
  CalendarView({ this.title}) ;

  @override
  _CalendarViewState createState() => new _CalendarViewState();
}

class _CalendarViewState extends State<CalendarView> {
  CalendarController _controller = CalendarController();
  String selectedDay = "";
  DateTime newDate;
  String error = "";
  bool dateChanged = false;
  Map<DateTime, List<dynamic>> _events;
  List<dynamic> _selectedEvents;
  final FirebaseAuth auth = FirebaseAuth.instance;
  bool dataOnThisDate = false;
  var userId;
  bool todaysDate = false;

  void initState() {
    super.initState();
    getUid();
    selectedDay = getCurrentDate();
    _events = {};
    _selectedEvents = [];
    markDatesThatHaveData();
  }

  Future<String> getUid() async {
    final FirebaseUser user = await auth.currentUser();
    final uid = user.uid;
    setState(() {
      userId = uid;
    });
    return uid;
  }

  markDatesThatHaveData(){

    _events[globals.newDate] = ["hi"];
  }

  showAlertDialog(BuildContext context, String message) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed:  () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Continue"),
      onPressed:  () {
        setState(() {
          globals.selectedDate = selectedDay;
          globals.newDateSelected = true;
          globals.newDate = newDate;
        });
        DatabaseService(uid: userId).createNewEntry(selectedDay);
        Navigator.pushNamedAndRemoveUntil(context,
            "/second",
              (r) => false,
              );
        }
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Confirm Action"),
      content: Text(message),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  String getCurrentDate(){
    var date = new DateTime.now().toString();
    var dateParse = DateTime.parse(date);
    var formattedDate = "${dateParse.day}/${dateParse.month}/${dateParse.year}";
    return formattedDate;
  }

  showSnackBar(String title, String message) {
    return Flushbar(
      duration: Duration(seconds: 2),
      flushbarPosition: FlushbarPosition.TOP,
      backgroundColor: Colors.redAccent,
      title: title,
      message: message,
    )
      ..show(context);
  }

  @override
  Widget build(BuildContext context) {
    // final dates = Provider.of<List<DateTime>>(context) ?? '';
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('users').document(userId).collection('entries').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          //
          if(snapshot.hasData) {
            for (var data in snapshot.data.documents) {
              DateTime date = data['entryDate'].toDate();
              _events[date] = ["x"];
            }
          }
          return Scaffold(
            appBar: new AppBar(
              title: new Text("View Previously Entered Logs"),
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    child: TableCalendar(
                      calendarController: _controller,
                      initialSelectedDay: globals.newDate,
                      events: _events,
                      availableCalendarFormats: const {
                        CalendarFormat.week: 'Two Weeks',
                        CalendarFormat.month: 'Week',
                        CalendarFormat.twoWeeks: "Month",
                      },
                      startingDayOfWeek: StartingDayOfWeek.monday,
                        onDaySelected: (date, events,e) {
                          newDate = date;
                          selectedDay = "${date.day}/${date.month}/${date.year}";
                          dataOnThisDate = false;
                          if(selectedDay != globals.selectedDate){
                            dateChanged = true;
                          } else {
                            dateChanged = false;
                          }
                        },
                    ),
                  ),
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(10.0),
                      child: ElevatedButton(
                        style: globals.buttonstyle,
                        onPressed: (){
                          if(dateChanged) {
                            for (var date in _events.keys) {
                              if ((newDate.day == date.day) && (newDate.month == date.month) && (newDate.year == date.year)){
                                //entry exists for this date
                                setState(() {
                                  dataOnThisDate = true;
                                });

                                if(newDate.year == DateTime.now().year && newDate.month == DateTime.now().month && newDate.day == DateTime.now().day){
                                  showAlertDialog(context, "Go back to today?");
                                } else {
                                  showAlertDialog(context, "Would you like to view data you entered on ${selectedDay}?");
                                }
                              }
                            }
                            if (!dataOnThisDate){
                              showAlertDialog(context, "You did not enter any data on ${selectedDay}. Would you like to go back and log some data?");
                              // showSnackBar("Error", "You did not enter any data on this date.");
                            }
                          } else {
                            setState(() {
                              showSnackBar("Error", "You have not selected a new date.");
                            });
                          }

                        },
                        child: Text("Select date"),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            );
          },
        );
  }
}