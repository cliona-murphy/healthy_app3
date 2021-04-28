import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cupertino_setting_control/cupertino_setting_control.dart';
import 'package:healthy_app/screens/home/settings_widgets.dart';
import 'package:healthy_app/services/database.dart';
import 'package:healthy_app/shared/loading.dart';
import 'package:healthy_app/shared/globals.dart' as globals;

class SettingsPage extends StatefulWidget {

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  String userId = "";
  bool loading = true;
  String _searchAreaResult = "";
  double _age = 0;
  double _weight = 0;
  double _kcalIntake = 0;
  double _kcalOutput = 0;
  double _waterIntake = 0;
  String waterIntake = "";
  String settingsUpdated = "false";


  void initState() {
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
    print(uid);
    return uid;
  }

  updateBoolean(){
    Future.delayed(const Duration(milliseconds: 1500), () {
      setState(() {
        loading = false;
      });
    });
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
        child: Text("Confirm"),
        onPressed:  () {
          //SettingsWidgets().pushChangesToDatabase();
          setState(() {
          });
          Navigator.pushNamedAndRemoveUntil(context,
            "/second",
                (r) => false,
          );
        }
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Please confirm"),
      content: Text("Would you like to save your changes?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void onSearchAreaChange(String data) {
    setState(() {
      _searchAreaResult = data;
    });
    //DatabaseService(uid: userId).enterUserCountry(_searchAreaResult);
  }

  void onWaterSearchAreaChange(String data){
    setState(() {
      waterIntake = data;
    });
    //DatabaseService(uid: userId).enterUserCountry(waterIntake);
  }


  @override
  Widget build(BuildContext context) {

    return StreamBuilder(
      stream: Firestore.instance.collection('settings').document(userId).snapshots(),
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        var country, age, weight, intakeTarget, outputTarget, waterTarget;
        if (snapshot.hasData) {
          country = snapshot.data['country'];
          age = snapshot.data['age'].toDouble();
          weight = snapshot.data['weight'].toDouble();
          intakeTarget = snapshot.data['kcalIntakeTarget'].toDouble();
          outputTarget = snapshot.data['kcalOutputTarget'].toDouble();
          waterTarget = snapshot.data['waterIntakeTarget'].toDouble();
        } else {
          country = '';
          age = 18;
          weight = 60;
        }
        if (loading) {
          return Loading();
        } else {
          return Scaffold(
          appBar: AppBar(
            leading: IconButton(icon:Icon(Icons.arrow_back),
              onPressed:() {
              if(globals.settingsChanged) {
                setState(() {
                  settingsUpdated = "true";
                  Navigator.pushNamedAndRemoveUntil(context, '/second', (r) => false, arguments: "test");
                });
              } else {
                Navigator.pop(context, settingsUpdated);
              }

              }),

            title: Text('Settings'),
          ),
            body: Padding(
                padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
                child: SettingsWidgets(country: country, age: age, weight: weight, intakeTarget: intakeTarget, outputTarget: outputTarget, waterTarget: waterTarget),
                    //country: country, age: age, weight: weight),
            ),
          );
        }
      });
  }
}
