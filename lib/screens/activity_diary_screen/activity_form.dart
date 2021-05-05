import 'package:cupertino_setting_control/cupertino_setting_control.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:healthy_app/models/activity.dart';
import 'package:healthy_app/services/database.dart';
import 'package:healthy_app/shared/globals.dart'as globals;

class ActivityForm extends StatefulWidget {

  final String action;
  final Activity activity;

  ActivityForm({ this.action, this.activity});
  @override
  _ActivityFormState createState() => _ActivityFormState();
}

class _ActivityFormState extends State<ActivityForm> {

  String activityType = 'Walking';
  double distance = 0;
  double duration = 0;
  double calories = 0;
  String distanceError = "";
  String durationError = "";
  String calorieError = "";
  String appBarAction = "";
  bool argsPassed = false;
  int distanceFrom = 0;
  int distanceTo = 100;
  int durationFrom = 0;
  int durationTo = 120;
  int caloriesFrom = 0;
  int caloriesTo = 1000;
  ValueNotifier<int> test = ValueNotifier<int>(0);
  final FirebaseAuth auth = FirebaseAuth.instance;
  String userId = "";
  TextEditingController distanceController = TextEditingController();
  TextEditingController durationController = TextEditingController();
  TextEditingController calorieController = TextEditingController();

  void initState(){
    super.initState();
    getUid();
    if (widget.action == "Edit"){
      setState(() {
        argsPassed = true;
        activityType = widget.activity.activityType;
        distance = widget.activity.distance;
        duration = widget.activity.duration;
        calories = widget.activity.calories;
        distanceController.text = widget.activity.distance.toString();
        durationController.text =  widget.activity.duration.toString();
        calorieController.text = widget.activity.calories.toString();
      });
    }
  }

  Future<String> getUid() async {
    final FirebaseUser user = await auth.currentUser();
    final uid = user.uid;
    setState(() {
      userId = uid;
    });
    return uid;
  }

  Future<String> getUserid() async {
    final FirebaseUser user = await auth.currentUser();
    final uid = user.uid;
    return uid;
  }

  void onSearchAreaChange(String data) {
    setState(() {
      activityType = data;
    });
    updateValuesAccordingToActivity(activityType);
  }

  updateValuesAccordingToActivity(String activityType) {
    String string = "";
    switch (activityType){
      case 'Walking':
        setState(() {
          distanceTo = 50;
          durationTo = 120;
        });
        break;
      case 'Running':
        setState(() {
          distanceTo = 50;
          durationTo = 120;
        });
        break;
      case 'Cycling':
        setState(() {
          distanceTo = 300;
          durationTo = 180;
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
  void addActivity() async {
    String userId = await getUserid();
    DatabaseService(uid: userId).addActivity(activityType, distance, duration, calories);
  }

  updateActivity() async {
    String userId = await getUserid();
    DatabaseService(uid: userId).updateActivity(widget.activity.docId, activityType, distance, duration, calories);
  }

  Future showPopUp(String title, String message){
    return showDialog(context: context, builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: Container(
          child: Text(message),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: argsPassed ? Text("${widget.action} your activity") : Text("Log your activity"),
        actions: [
           FlatButton(
            onPressed: () {
              if(distance == 0.0 || duration == 0.0 || calories == 0.0) {
                if (distance == 0.0) {
                  setState(() {
                    distanceError = "Please supply a distance.";
                  });
                }
                if (duration == 0.0) {
                  setState(() {
                    durationError = "Please supply a duration.";
                  });
                }
                if (calories == 0.0) {
                  setState(() {
                    calorieError = "Please enter the calories you burned.";
                  });
                }
              } else {
                if(widget.action == "Edit"){
                  updateActivity();
                  Navigator.pop(context, "test");
                } else {
                  addActivity();
                  Navigator.pop(context, "test");
                }
              }
            },
            child: Row(
              children: [
                Text("SAVE ",
                style: TextStyle(
                  color: Colors.white,
                ),),
                Icon(
                  Icons.save_outlined,
                  color: Colors.white,
                  size: 26.0,
                ),
              ],
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0),
                    child: Text(
                      "What type of activity did you do?",
                      style: TextStyle(
                        color: Color.fromRGBO(157, 131, 212, 1.0),
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                   Padding(padding: const EdgeInsets.only(top: 10.0),),
                   SettingRow(
                     style: globals.settingsStyle,
                    rowData: SettingsDropDownConfig(
                        title: 'Activity',
                        initialKey: activityType,
                        choices: {
                          'Walking': 'Walking',
                          'Running': 'Running',
                          'Cycling': 'Cycling',
                          'Swimming': 'Swimming',
                        }),
                    onSettingDataRowChange: onSearchAreaChange,
                    config: SettingsRowConfiguration(
                        showAsTextField: false,
                       // showTitleLeft: !_titleOnTop,
                       // showTopTitle: _titleOnTop,
                        showAsSingleSetting: false),
                  ),
                  Padding(padding: const EdgeInsets.only(top: 10.0),),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, top: 15.0),
                    child: Text(
                      "What distance did you do?",
                      style: TextStyle(
                        color: Color.fromRGBO(157, 131, 212, 1.0),
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(padding: const EdgeInsets.only(top: 10.0),),
                  Container(
                        width: 500,
                        height: 60,
                        color: Colors.white,
                        child: Row(
                          children: [
                            Container(
                                padding: EdgeInsets.fromLTRB(25.0, 5.0, 25.0, 5.0),
                                width: 190,
                                child: Text("Distance (km)",
                                    style: TextStyle(
                                      fontSize: 20,
                                    ))),
                            Container(
                              width: 40,
                              child: GestureDetector(
                                child: Icon(Icons.help),
                                onTap: () => showPopUp("Distance", "Please get this information from an activity tracking "
                                    "app or device such as Fitbit and enter it (in kilometres) here."),
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.fromLTRB(25.0, 0.0, 0.0, 0.0),
                              width: 140,
                              child: Container(
                                height: 40,
                                child: TextField(
                                  keyboardType: TextInputType.number,
                                  // maxLength: 4,
                                  // maxLengthEnforced: true,
                                  inputFormatters: [new WhitelistingTextInputFormatter(RegExp("[0-9.]")), LengthLimitingTextInputFormatter(5)],
                                  onChanged: (text) async {
                                    double value = double.parse(text);
                                    if (value > 0) {
                                      // if (value <= 5000) {
                                      setState(() {
                                        distance = value;
                                        distanceError = "";
                                      });
                                    } else {
                                      setState(() {
                                        // intakeError = "Enter value in range 1500-5000";
                                        // globals.showSnackBar(context, "Error", "Please enter a value in the range [1500, 5000]");
                                      });
                                    }
                                  },
                                  controller: distanceController,
                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                    ),
                                    // hintText: widget.intakeTarget.toInt().toString(),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 40.0, top: 5.0),
                    child: Text(
                      distanceError,
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, top: 0.0),
                    child: Text(
                      "How long did it take you?",
                      style: TextStyle(
                        color: Color.fromRGBO(157, 131, 212, 1.0),
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(padding: const EdgeInsets.only(top: 10.0),),
                  Container(
                    width: 500,
                    height: 60,
                    color: Colors.white,
                    child: Row(
                      children: [
                        Container(
                            padding: EdgeInsets.fromLTRB(25.0, 5.0, 25.0, 5.0),
                            width: 190,
                            child: Text("Duration (mins)",
                                style: TextStyle(
                                  fontSize: 20,
                                ))),
                        Container(
                          width: 40,
                          child: GestureDetector(
                            child: Icon(Icons.help),
                            onTap: () => showPopUp("Duration",  "Please make sure to time your activity or get this information from an"
                                " activity tracking app or device such as Fitbit and enter it (in minutes) here."),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(25.0, 0.0, 0.0, 0.0),
                          width: 140,
                          child: Container(
                            height: 40,
                            child: TextField(
                              keyboardType: TextInputType.number,
                              inputFormatters: [new WhitelistingTextInputFormatter(RegExp("[0-9.]")), LengthLimitingTextInputFormatter(5)],
                              onChanged: (text) async {
                                double value = double.parse(text);
                                if (value > 0) {
                                  setState(() {
                                    durationError = "";
                                    duration = value;
                                  });
                                }
                              },
                              controller: durationController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 40.0, top: 0.0),
                    child: Text(
                      durationError,
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, top: 10.0),
                    child: Text(
                      "How many calories did you burn?",
                      style: TextStyle(
                        color: Color.fromRGBO(157, 131, 212, 1.0),
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Padding(padding: const EdgeInsets.only(top: 10.0),),
                  Container(
                    width: 500,
                    height: 60,
                    color: Colors.white,
                    child: Row(
                      children: [
                        Container(
                            padding: EdgeInsets.fromLTRB(25.0, 5.0, 25.0, 5.0),
                            width: 190,
                            child: Text("Calories (kcal)",
                                style: TextStyle(
                                  fontSize: 20,
                                ))),
                        Container(
                          width: 40,
                          child: GestureDetector(
                            child: Icon(Icons.help),
                            onTap: () => showPopUp("Calories",  "Please get this information from an activity tracking "
                                "app or device such as Fitbit or use an online calculator and enter it (in kilocalories) here."),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(25.0, 0.0, 0.0, 0.0),
                          width: 140,
                          child: Container(
                            height: 40,
                            child: TextField(
                              keyboardType: TextInputType.number,
                              inputFormatters: [new WhitelistingTextInputFormatter(RegExp("[0-9.]")), LengthLimitingTextInputFormatter(5)],
                              onChanged: (text) async {
                                double value = double.parse(text);
                                print(value);
                                if (value > 0) {
                                  setState(() {
                                    calorieError = "";
                                    calories = value;
                                  });
                                } else {
                                  setState(() {
                                    // intakeError = "Enter value in range 1500-5000";
                                    // globals.showSnackBar(context, "Error", "Please enter a value in the range [1500, 5000]");
                                  });
                                }
                              },
                              controller: calorieController,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                ),
                                // hintText: widget.intakeTarget.toInt().toString(),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 40.0, top: 0.0),
                    child: Text(
                      calorieError,
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
// SettingRow(
// style: globals.settingsStyle,
// rowData: SettingsSliderConfig(
// title: 'Distance',
// from: 0,
// to: 120,
// initialValue: distance,
// justIntValues: true,
// unit: ' km',
// ),
// onSettingDataRowChange: (double resultVal) {
// setState(() {
// distance = resultVal;
// });
// },
// config: SettingsRowConfiguration(
// showAsTextField: false,
// // showTitleLeft: !_titleOnTop,
// // showTopTitle: _titleOnTop,
// showAsSingleSetting: false),
// ),
// // },
// // valueListenable: test,
// // ),
// SettingRow(
//   style: globals.settingsStyle,
//   rowData: SettingsSliderConfig(
//     title: 'Duration',
//     from: 0,
//     to: durationTo.toDouble(),
//     initialValue: duration,
//     justIntValues: true,
//     unit: ' minutes',
//   ),
//   onSettingDataRowChange: (double resultVal) {
//     setState(() {
//       duration = resultVal;
//     });
//   },
//   config: SettingsRowConfiguration(
//       showAsTextField: false,
//       // showTitleLeft: !_titleOnTop,
//       // showTopTitle: _titleOnTop,
//       showAsSingleSetting: false),
// ),