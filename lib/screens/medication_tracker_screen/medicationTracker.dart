import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:healthy_app/models/medication.dart';
import 'package:healthy_app/models/medication_checklist.dart';
import 'package:healthy_app/services/auth.dart';
import 'package:healthy_app/services/database.dart';
import 'package:healthy_app/shared/loading.dart';
import 'package:provider/provider.dart';
import 'medication_list.dart';
import 'package:healthy_app/shared/globals.dart' as globals;

class MedicationTracker extends StatefulWidget {
  //test comment
  @override
  _MedicationTrackerState createState() => _MedicationTrackerState();
}

class _MedicationTrackerState extends State<MedicationTracker> {
  final AuthService _auth = AuthService();
  final FirebaseAuth auth = FirebaseAuth.instance;

  var userId;
  bool userIdSet = false;
  bool loading = true;

  TextEditingController nameController = TextEditingController();
  TextEditingController timeController = TextEditingController();

  TimeOfDay _time = TimeOfDay.now();
  TimeOfDay selectedTime;
  String timeString;
  bool timeSelected = false;
  String medName;

  void initState(){
    super.initState();
    getUid();
    updateBoolean();
  }

  void selectTime(BuildContext context) async {
    //animate this?
      selectedTime = await showTimePicker(
        context: context,
        initialTime: _time,
        initialEntryMode: TimePickerEntryMode.input,
      );
      timeSelected = true;
      timeString = "${selectedTime.hour}:${selectedTime.minute}";
  }


  Future<String> addItem(BuildContext context) {
      return showDialog(context: context, builder: (context) {
        return AlertDialog(
          title: Text("Enter details here:"),
          content: Container(
            height: 100,
            child : SingleChildScrollView(
              child: Column(
                children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      hintText: "medication/supplement name",
                    ),
                  ),
                  Padding(padding: EdgeInsets.only(top: 15.0)),
                  Container(
                    child: FlatButton(
                      color: Colors.grey,
                      child: Text("Select Time"),
                      onPressed: () {
                        selectTime(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget> [
            MaterialButton(
              elevation: 5.0,
              child: Text("Submit"),
              onPressed: () {
                setState(() {
                  medName = nameController.text;
                });
                nameController.clear();
                timeController.clear();
                Navigator.pop(context);
                showConfirmationDialog();

                //updateDatabase(nameController.text, timeString);

              },
            ),
          ],
        );
      });
  }

  showConfirmationDialog() {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed:  () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = FlatButton(
        child: Text("Confirm"),
        onPressed:  () {
          updateDatabase(medName, timeString);
          Navigator.pop(context);
        }
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Confirm Action"),
      content: Text("Add "+medName+" to be taken at "+timeString+" to list?"),
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

  Future updateDatabase(String medName, String timeToTake) async {
    userId = await getUid();
    DatabaseService(uid: userId).addMedication(medName, timeToTake);
  }

  Future<String> getUid() async {
    final FirebaseUser user = await auth.currentUser();
    final uid = user.uid;
    setState(() {
      userId = uid;
    });
    setState(() {
      userIdSet = true;
    });
    return uid;
  }

  updateBoolean(){
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        loading = false;
      });
    });
  }

  Widget build(BuildContext context){
    return StreamProvider<List<Medication>>.value(
      value: DatabaseService(uid: userId).medications,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            height: 600,
            child: Center(
              child: Column(
                  children: [
                      Padding(padding: EdgeInsets.only(top: 30.0)),
                      StreamProvider<List<MedicationChecklist>>.value(
                          value: DatabaseService(uid: userId).getLoggedMedications(),
                        child: MedicationList(),
                      ),
                      Container(
                        padding: const EdgeInsets.all(10.0),
                        child: ElevatedButton(
                          onPressed: (){
                            addItem(context);
                          },
                          child: Text("Add Item"),
                        ),
                      ),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}