import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:healthy_app/models/arguments.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:healthy_app/screens/home/home.dart' as HomePage;
import 'package:healthy_app/shared/globals.dart' as globals;

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

  void initState() {
    super.initState();
    selectedDay = getCurrentDate();
  }

  showAlertDialog(BuildContext context) {
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
        Navigator.pushNamedAndRemoveUntil(context,
            "/second",
              (r) => false,
              );
        }
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Confirm Action"),
      content: Text("Would you like to view data you entered on ${selectedDay}?"),
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
    return new Scaffold(
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
                  availableCalendarFormats: const {
                    CalendarFormat.week: 'Two Weeks',
                    CalendarFormat.month: 'Week',
                    CalendarFormat.twoWeeks: "Month",
                  },
                  startingDayOfWeek: StartingDayOfWeek.monday,
                    onDaySelected: (date, events,e) {
                      newDate = date;
                      selectedDay = "${date.day}/${date.month}/${date.year}";
                      dateChanged = true;
                    },
                ),
              ),
              Center(
                child: Container(
                  padding: const EdgeInsets.all(10.0),
                  child: ElevatedButton(
                    onPressed: (){
                      if(dateChanged) {
                        showAlertDialog(context);
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
        ));
  }
}