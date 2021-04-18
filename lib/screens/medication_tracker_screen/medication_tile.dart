import 'package:healthy_app/models/medication.dart';
import 'package:flutter/material.dart';
import 'package:healthy_app/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
    DatabaseService(uid: userId).medTaken(medName, checked);
  }

  updateDetails(String originalMedName, String newMedName, String timeToTake) async {
    String userId = await getUserid();
    DatabaseService(uid: userId).updateMedicationDetails(originalMedName, newMedName, timeToTake);
  }
  updateTime(String medName, String timeToTake) async {
    String userId = await getUserid();
    DatabaseService(uid: userId).updateMedicationTime(medName, timeToTake);
  }

  deleteMedication(String medName) async {
    String userId = await getUserid();
    DatabaseService(uid: userId).deleteMedication(medName);
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
         // if (medName == ""){
            updateTime(widget.medication.medicineName, timeString);
          //} else {
           // updateDetails(widget.medication.medicineName, medName, timeString);
          //}
          Navigator.pop(context);
        }
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Confirm Action"),
      content: Text("Update time to take "+widget.medication.medicineName+" to "+timeString+"?"),
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

  Future<String> editItem(BuildContext context, String medName, String timeToTake) {
    return showDialog(context: context, builder: (context) {
      return AlertDialog(
        title: Text("Edit "+medName+" details here:"),
        content: Container(
          height: 60,
          child : SingleChildScrollView(
            child: Column(
              children: [
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
          IconButton(
            icon: Icon(Icons.delete),
            color: Colors.red,
            onPressed: () {
              deleteMedication(widget.medication.medicineName);
              nameController.clear();
              timeController.clear();
              Navigator.pop(context);
            },
          ),
          MaterialButton(
            elevation: 5.0,
            child: Text("Update"),
            onPressed: () {
              setState(() {
                medName = nameController.text;
              });
              nameController.clear();
              timeController.clear();
              Navigator.pop(context);
              showConfirmationDialog();
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
            title: Text(widget.medication.medicineName,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20.0),),
            subtitle: widget.taken ? Text("Taken at ${widget.timeTaken}") :
            Text("Take at ${widget.medication.timeToTake}"),
            secondary: IconButton(
              icon: Icon(Icons.edit),
              onPressed: (){
                editItem(context, widget.medication.medicineName, widget.medication.timeToTake);
                setState(() {
                });
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