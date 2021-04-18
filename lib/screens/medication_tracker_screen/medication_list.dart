import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:healthy_app/models/medication_checklist.dart';
import 'package:healthy_app/shared/loading.dart';
import 'package:provider/provider.dart';
import 'package:healthy_app/models/medication.dart';
import 'medication_tile.dart';

class MedicationList extends StatefulWidget {
  @override
  _MedicationListState createState() => _MedicationListState();
}

class _MedicationListState extends State<MedicationList> {

  bool loading = true;
  String timeTaken = "";

  void initState(){
    super.initState();
    updateBoolean();
  }
  updateBoolean(){
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        loading = false;
      });
    });
  }

  bool checkIfTaken(Medication medication, List<MedicationChecklist> medsLogged){
      bool returnBool = false;
      for(var loggedMed in medsLogged){
        if (medication.medicineName == loggedMed.medicineName){
          if (loggedMed.taken){
            returnBool = true;
            timeTaken = loggedMed.timeTaken;
          } else {
            returnBool = false;
          }
        }
      }
      return returnBool;
    }

  @override
  Widget build(BuildContext context) {
    final medications = Provider.of<List<Medication>>(context) ?? [];
    final loggedMedications = Provider.of<List<MedicationChecklist>>(context) ?? [];

    if(medications.isNotEmpty){

      return loading ? Loading() : ListView.builder(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        itemCount: medications.length,
        itemBuilder: (context, index) {
          return MedicationTile(medication: medications[index], taken: checkIfTaken(medications[index], loggedMedications), timeTaken: timeTaken);
        },
      );
    } else {
      return loading ? Loading() : Container(
        height: 190,
        width: 500,
        padding: const EdgeInsets.fromLTRB(30, 15, 30, 15),
        child: Column(
          children: [
            Text('This is your medication tracker.',
            textAlign: TextAlign.center,
            style: new TextStyle(
            color: Colors.grey[900], fontSize: 25.0),
          ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
            ),
            Text('You can add medications or supplements that you take daily'
            ' to the tracker by clicking the button below. Everyday you should check'
            ' your medication off the list when you take it!',
              textAlign: TextAlign.center,
              style: new TextStyle(
                  color: Colors.grey[600], fontSize: 20.0),
            ),

        ]),
      );
    }
  }
}