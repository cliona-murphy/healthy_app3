import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  String stringtest = "";
  bool test = false;

  void initState(){
    super.initState();
    getUid();
    updateBoolean();
    stringtest = "";
  }

  void selectTime(BuildContext context) async {
      selectedTime = await showTimePicker(
        context: context,
        initialTime: _time,
        initialEntryMode: TimePickerEntryMode.input,
      );
      setState(() {
        timeSelected = true;
      });
      String selectedTimeMinuteString = selectedTime.minute.toString();
      if (selectedTime.minute < 10){
        selectedTimeMinuteString = "0${selectedTime.minute}";
      }
      timeString = "${selectedTime.hour}:${selectedTimeMinuteString}";
      setState(() {
        globals.selectedTime = timeString;
      });

      globals.showSnackBar(context, "Success!", "You selected ${timeString}");

  }

  Future<String> addItem(BuildContext context) {
      return showDialog(context: context, barrierDismissible: false, builder: (context) {
        return AlertDialog(
          title: Text("Enter details here:"),
          content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
           return Container(
              height: 150,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      controller: nameController,
                      maxLength: 30,
                      maxLengthEnforced: true,
                      inputFormatters: [new WhitelistingTextInputFormatter(
                          RegExp("[a-zA-Z 0-9]")),
                      ],
                      decoration: InputDecoration(
                        hintText: "medication/supplement name",
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 15.0)),
                    // Align(
                    //     alignment: Alignment.centerLeft,
                    //     child: Text(stringtest)
                    // ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        child: FlatButton(
                          color: Colors.grey,
                          child: Text("Select Time"),
                          onPressed: () {
                            selectTime(context);
                            if (timeSelected){
                              setState(() {
                                stringtest = timeString;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
          actions: <Widget> [
            MaterialButton(
              elevation: 5.0,
              child: Text("Cancel"),
              onPressed: () {
                setState(() {
                  stringtest = "";
                });
                Navigator.pop(context);
              },
            ),
            MaterialButton(
              elevation: 5.0,
              child: Text("Submit"),
              onPressed: () {
                setState(() {
                  medName = nameController.text;
                });
                nameController.clear();
                timeController.clear();
                setState(() {
                  stringtest = "";
                });
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
      barrierDismissible: false,
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

  updateBooleanTest(){
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        test = true;
      });
    });
  }

  Widget build(BuildContext context){
    final medications = Provider.of<List<Medication>>(context) ?? [];

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
                      Padding(padding: EdgeInsets.fromLTRB(0, 30.0, 0, 0.0)),
                      StreamProvider<List<MedicationChecklist>>.value(
                          value: DatabaseService(uid: userId).getLoggedMedications(),
                        child: MedicationList(),
                      ),
                      Padding(padding: EdgeInsets.fromLTRB(0, 30.0, 0, 0.0)),
                      Container(
                        width: 150,
                        height: 60,
                        padding: const EdgeInsets.all(10.0),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.resolveWith<Color>(
                                  (Set<MaterialState> states) {
                                if (states.contains(MaterialState.pressed))
                                  return globals.lightPurple;
                                return globals.darkPurple; // Use the component's default.
                              },
                            ),
                          ),
                          onPressed: (){
                            addItem(context);
                            setState(() {
                              stringtest = "";
                            });
                          },
                          child: Text("Add Item",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                          ),
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