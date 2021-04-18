import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:healthy_app/models/activity.dart';
import 'package:healthy_app/models/medication_checklist.dart';
import 'package:healthy_app/shared/loading.dart';
import 'package:provider/provider.dart';
import 'package:healthy_app/models/medication.dart';

import 'activity_tile.dart';


class ActivityList extends StatefulWidget {
  @override
  _ActivityListState createState() => _ActivityListState();
}

class _ActivityListState extends State<ActivityList> {

  bool loading = true;

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
        } else {
          returnBool = false;
        }
      }
    }
    return returnBool;
  }

  @override
  Widget build(BuildContext context) {
    final activities = Provider.of<List<Activity>>(context) ?? [];
    print("activies:");
    print(activities);
    if(activities.isNotEmpty){

      return loading ? Loading() : ListView.builder(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        itemCount: activities.length,
        itemBuilder: (context, index) {
          return ActivityTile(activity: activities[index]);
        },
      );
    } else {
      return loading ? Loading() : Container(
        height: 130,
        width: 500,
        padding: const EdgeInsets.fromLTRB(30, 15, 30, 15),
        child: Column(
          children: [
            Text('This is your activity diary.',
            textAlign: TextAlign.center,
            style: new TextStyle(
                color: Colors.grey[900], fontSize: 25.0),
          ),
            Padding(padding: const EdgeInsets.fromLTRB(30, 5, 30, 15),),
            Text('You can add an activity to the diary by clicking the button below.',
              textAlign: TextAlign.center,
              style: new TextStyle(
                  color: Colors.grey[600], fontSize: 20.0),
            ),
        ]),
      );
    }
  }
}