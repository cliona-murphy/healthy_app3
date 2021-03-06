import 'package:flushbar/flushbar.dart';
import 'package:healthy_app/models/activity.dart';
import 'package:healthy_app/models/medication.dart';
import 'package:flutter/material.dart';
import 'package:healthy_app/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'activity_form.dart';
import 'package:healthy_app/shared/globals.dart' as globals;

class ActivityTile extends StatefulWidget {

  final Activity activity;
  ActivityTile({ this.activity });

  @override
  _ActivityTileState createState() => _ActivityTileState();
}

class _ActivityTileState extends State<ActivityTile> {
  Medication _medication;
  final FirebaseAuth auth = FirebaseAuth.instance;
  // timeDilation = 1.0;
  TextEditingController nameController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  bool isSelected = true;
  TimeOfDay _time = TimeOfDay.now();
  TimeOfDay selectedTime;
  String timeString;
  bool timeSelected = false;
  String medName = "";

  void initState(){
    super.initState();
    setState(() {
      //isSelected = widget.taken;
    });
  }
  Future<String> getUserid() async {
    final FirebaseUser user = await auth.currentUser();
    final uid = user.uid;
    return uid;
  }

  deleteActivity() async {
    String userId = await getUserid();
    DatabaseService(uid: userId).deleteActivity(widget.activity.docId);
    globals.showSnackBar(context, "Success!", "Your activity was successfully deleted.");
  }

  renderActivityFormToEdit(BuildContext context) async{
    final result = await
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ActivityForm(action: 'Edit', activity: widget.activity),
        ));
    if(result.isNotEmpty){
      setState(() {
        globals.showSnackBar(context, "Success!", "Your activity was successfully edited.");
      });
    }
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel",
        style: TextStyle(
          color: globals.lightPurple,
        ),),
      onPressed:  () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = FlatButton(
        child: Text("Confirm",
          style: TextStyle(
            color: globals.lightPurple,
          ),),
        onPressed:  () {
          deleteActivity();
          Navigator.pop(context);
        }
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Confirm Action",
      ),
      content: Text("Do you want to delete this activity? (${widget.activity.activityType})"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  String checkActivityType(String activityType) {
    String string = "";
    switch (activityType){
      case 'Walking':
        setState(() {
          string = "walked";
        });
        break;
      case 'Running':
        setState(() {
          string = "ran";
        });
        break;
      case 'Cycling':
        setState(() {
          string = "cycled";
        });
        break;
      case 'Swimming':
        setState(() {
          string = "swam";
        });
        break;
    }
    return string;
  }

  Icon getIcon(String activityType) {
    Icon icon;
    switch(activityType){
      case 'Walking':
        icon = Icon(FontAwesomeIcons.walking);
        break;
      case 'Running':
        icon = Icon(FontAwesomeIcons.running);
        break;
      case 'Cycling':
        icon = Icon(FontAwesomeIcons.biking);
        break;
      case 'Swimming':
        icon = Icon(FontAwesomeIcons.swimmer);
        break;
    }
    return icon;

  }

  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child:  Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            ListTile(
              leading: getIcon(widget.activity.activityType.toString()),
              title: Text(widget.activity.activityType.toString(), style: TextStyle(fontSize: 23),),
              subtitle: Text("${widget.activity.calories.toInt()} calories",
                style: TextStyle(color: Colors.black.withOpacity(0.6), fontSize: 17),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
              child: Text(
                'You ${checkActivityType(widget.activity.activityType)} ${widget.activity.distance.toInt()} km in ${widget.activity.duration.toInt()} minutes',
                style: TextStyle(color: Colors.black.withOpacity(0.6), fontSize: 17),
              ),
            ),
            ButtonBar(
              alignment: MainAxisAlignment.center,
              children: [
                FlatButton(
                  textColor: const Color(0xFF6200EE),
                  onPressed: () {
                    renderActivityFormToEdit(context);
                  },
                  child: const Text('EDIT'),
                ),
                FlatButton(
                  textColor: const Color(0xFF6200EE),
                  onPressed: () {
                    showAlertDialog(context);
                  },
                  child: const Text('DELETE'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}