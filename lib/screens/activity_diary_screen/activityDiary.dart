import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:healthy_app/models/activity.dart';
import 'package:healthy_app/models/medication.dart';
import 'package:healthy_app/models/medication_checklist.dart';
import 'package:healthy_app/screens/activity_diary_screen/activity_list.dart';
import 'package:healthy_app/screens/medication_tracker_screen/medication_list.dart';
import 'package:healthy_app/services/auth.dart';
import 'package:healthy_app/services/database.dart';
import 'package:healthy_app/shared/loading.dart';
import 'package:provider/provider.dart';
import 'package:flushbar/flushbar.dart';
import'package:healthy_app/shared/globals.dart' as globals;

import 'activity_form.dart';

class ActivityDiary extends StatefulWidget {

  @override
  _ActivityDiaryState createState() => _ActivityDiaryState();
}

class _ActivityDiaryState extends State<ActivityDiary> {
  final AuthService _auth = AuthService();
  final FirebaseAuth auth = FirebaseAuth.instance;
  String userId = "";
  bool loading = true;

  void initState(){
    super.initState();
    getUid();
    updateBoolean();
  }

  Future<String> getUid() async {
    final FirebaseUser user = await auth.currentUser();
    final uid = user.uid;
    setState(() {
      userId = uid;
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

  renderActivityForm(BuildContext context) async {
    final result = await
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ActivityForm(action: 'Log'),
        ));
    // if(result.isNotEmpty){
    //   setState(() {
    //     globals.showSnackBar(context, "Success", "Your activity was successfully logged.");
    //   });
    // }
  }

  void addItem(BuildContext context){
    renderActivityForm(context);
  }

  Widget build(BuildContext context){
    return StreamProvider<List<Activity>>.value(
      value: DatabaseService(uid: userId).activities,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            child: Center(
              child: Column(
                  children: [
                    Padding(padding: EdgeInsets.only(top: 30.0)),
                    ActivityList(),
                    Container(
                      height: 60,
                      width: 150,
                      padding: const EdgeInsets.all(10.0),
                      child: ElevatedButton(
                        style: globals.buttonstyle,
                        onPressed: (){
                          addItem(context);
                          //addItem(context);
                        },
                        child: Text("Add Item",
                          style: TextStyle(
                          fontSize: 20,
                        ),),
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