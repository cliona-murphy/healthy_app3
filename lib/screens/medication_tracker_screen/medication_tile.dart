import 'package:flutter/services.dart';
import 'package:healthy_app/models/medication.dart';
import 'package:flutter/material.dart';
import 'package:healthy_app/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:healthy_app/shared/globals.dart' as globals;

class MedicationTile extends StatefulWidget {

  final Medication medication;
  final bool taken;
  final String timeTaken;
  MedicationTile({ this.medication, this.taken, this.timeTaken });

  @override
  _MedicationTileState createState() => _MedicationTileState();
}

class _MedicationTileState extends State<MedicationTile> {
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
      isSelected = widget.taken;
    });
    timeController.text = widget.medication.timeToTake.toString();
  }

  Future<String> getUserid() async {
    final FirebaseUser user = await auth.currentUser();
    final uid = user.uid;
    return uid;
  }

  checkIfTaken() async {
    String userId = await getUserid();
    //DatabaseService(uid: userId).checkIfMedTaken(widget.medication.medicineName);
  }
  updateDatabase(bool checked, String medName) async {
    String userId = await getUserid();
    bool documentExists = await DatabaseService(uid: userId).doesNameAlreadyExist(medName);
    DatabaseService(uid: userId).medTaken(medName, checked, documentExists);
  }

  updateDetails(String newMedName, String timeToTake) async {
    print("updateDetails called");
    String userId = await getUserid();
    DatabaseService(uid: userId).updateMedicationDetails(widget.medication.docId, newMedName, timeToTake);
  }
  updateTime(String timeToTake) async {
    String userId = await getUserid();
    DatabaseService(uid: userId).updateMedicationTime(widget.medication.docId, timeToTake);
  }

  deleteMedication(String medName) async {
    String userId = await getUserid();
    bool documentExists = await DatabaseService(uid: userId).doesNameAlreadyExist(medName);
    if (documentExists) {
      DatabaseService(uid: userId).deleteMedicationEntryFromChecklist(medName);
    }
    DatabaseService(uid: userId).deleteMedication(widget.medication.docId);
  }

  updateTimeTaken(String medName) async {
    String userId = await getUserid();
    DatabaseService(uid: userId).updateTimeTaken(medName);
  }

  void selectTime(BuildContext context) async {
    //animate this?
    selectedTime = await showTimePicker(
      context: context,
      initialTime: _time,
      initialEntryMode: TimePickerEntryMode.input,
    );
    timeSelected = true;
    String filler = "";
    if(selectedTime.minute.toString() == "0") {
      filler = "0";
    }
    timeString = "${selectedTime.hour}:${selectedTime.minute}${filler}";
    setState(() {
      timeController.text = timeString;
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
          deleteMedication(widget.medication.medicineName);
          Navigator.pop(context);
          Navigator.pop(context);
        }
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Confirm Action"),
      content: Text("Do you want to delete "+widget.medication.medicineName+"?"),
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

  Future<String> editItem(BuildContext context, String medName, String timeToTake) {
    setState(() {
      nameController.text = widget.medication.medicineName;
      timeController.text = widget.medication.timeToTake;
    });
    return showDialog(context: context, barrierDismissible: false, builder: (context) {
      return AlertDialog(
        title: Text("Edit "+medName+" details here:"),
        content: Container(
          height: 170,
          child : SingleChildScrollView(
            child: Column(
              children: [
                Padding(padding: EdgeInsets.only(top: 15.0),),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextField(
                    controller: nameController,
                  ),
                ),
                TextField(
                  // enabled: false,
                  controller: timeController,
                  decoration: InputDecoration(
                    hintText: timeController.text
                  ),
                ),
                Padding(padding: EdgeInsets.only(top: 15.0),),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    child: FlatButton(
                      color: Colors.grey,
                      child: Text("Edit Time"),
                      onPressed: () {
                        selectTime(context);
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: <Widget> [
          MaterialButton(
            elevation: 5.0,
            child: Text("Cancel"),
            onPressed: () {
              nameController.clear();
              // timeController.clear();
              Navigator.pop(context);
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            color: Colors.red,
            onPressed: () {
              // globals.showAlertDialog(context, deleteMedication(widget.medication.medicineName), "Are you sure you want to delete this medication?", widget.medication.medicineName);
              showConfirmationDialog();
            },
          ),
          MaterialButton(
            elevation: 5.0,
            child: Text("Update"),
            onPressed: () {
              setState(() {
                print(timeString);
                if(timeString != null && nameController.text.isNotEmpty){
                  medName = nameController.text;
                  updateDetails(medName, timeString);
                } else if (nameController.text.isNotEmpty) {
                  updateDetails(nameController.text, widget.medication.timeToTake);
                }
              });
              nameController.clear();
              // timeController.clear();
              Navigator.pop(context);
              // showConfirmationDialog();
              //updateDetails(widget.medication.medicineName, nameController.text, timeController.text);
            },
          ),
        ],
      );
    });
  }

  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
          child: CheckboxListTile(
            checkColor: Colors.white,
            activeColor: globals.lightPurple,
            title: Text(widget.medication.medicineName,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0),),
            subtitle: widget.taken ? Text("Taken at ${widget.timeTaken}",
            style: TextStyle(
              fontSize: 20,
            ),
            ) :
            Text("Take at ${widget.medication.timeToTake}",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            secondary: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () async {
                editItem(context, widget.medication.medicineName, widget.medication.timeToTake);
                // selectedTime = await showTimePicker(context: context, initialTime: TimeOfDay.now(), initialEntryMode: TimePickerEntryMode.input,);
                // String selectedTimeMinuteString = selectedTime.minute.toString();
                // if (selectedTime.minute < 10){
                //   selectedTimeMinuteString = "0${selectedTime.minute}";
                // }
                // timeString = "${selectedTime.hour}:${selectedTimeMinuteString}";
                // setState(() {
                //   globals.selectedTime = timeString;
                // });
                // updateTime(timeString);
                // globals.showSnackBar(context, "Success", "Time to take ${widget.medication.medicineName} was updated to ${timeString}.");
              },
            ),
            value: isSelected,
             onChanged: (bool newValue) {
              setState(() {
                updateDatabase(newValue, widget.medication.medicineName);
                isSelected = newValue;
                if(isSelected){
                  updateTimeTaken(widget.medication.medicineName);
                }
          });
        },
      ),
    ),
    );
  }
}