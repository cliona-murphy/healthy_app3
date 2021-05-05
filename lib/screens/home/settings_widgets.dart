import 'package:cupertino_setting_control/cupertino_setting_control.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:healthy_app/services/database.dart';
import 'package:healthy_app/shared/globals.dart' as globals;

class SettingsWidgets extends StatefulWidget {
  final String country;
  final double age;
  final double weight;
  final double intakeTarget;
  final double outputTarget;
  final double waterTarget;
  SettingsWidgets({this.country, this.age, this.weight, this.intakeTarget, this.outputTarget, this.waterTarget });

  @override
  _SettingsWidgetsState createState() => _SettingsWidgetsState();
}

class _SettingsWidgetsState extends State<SettingsWidgets> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  String userId = "";
  bool _titleOnTop = false;
  String _searchAreaResult = "";
  double _age = 0;
  double _weight = 0;
  double _kcalIntake = 0;
  double _kcalOutput = 0;
  double _waterIntake = 0;
  String waterIntake = "";
  TextEditingController intakeController;
  String intakeError = "";
  TextEditingController outputController;


  void initState() {
    setState(() {
      globals.settingsChanged = false;
    });
    super.initState();
    getUid();
    intakeController = TextEditingController();
    outputController = TextEditingController();
    // intakeController.addListener(updateIntakeTarget);
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

  void onSearchAreaChange(String data) {
    setState(() {
      _searchAreaResult = data;
      globals.settingsChanged = true;
    });
    //DatabaseService(uid: userId).enterUserCountry(_searchAreaResult);
  }

  void onWaterSearchAreaChange(String data){
    setState(() {
      waterIntake = data;
      globals.settingsChanged = true;
    });
    //DatabaseService(uid: userId).enterUserCountry(waterIntake);
  }

  void pushChangesToDatabase(){

  }

  void updateIntakeTarget() {
    DatabaseService(uid: userId).updateKcalIntakeTarget(int.parse(intakeController.text));
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
    final titleOnTopSwitch = SettingRow(
        rowData: SettingsYesNoConfig(
            initialValue: _titleOnTop, title: 'Title on top'),
        config: const SettingsRowConfiguration(showAsSingleSetting: true),
        onSettingDataRowChange: (newVal) => setState(() {
          _titleOnTop = newVal;
        }));

    final profileSettingsTile = new Material(
      color: Colors.transparent,
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Padding(
              padding: EdgeInsets.fromLTRB(25.0, 5.0, 25.0, 5.0),
              child: const Text(
                'Profile',
                style: TextStyle(
                  color: Color.fromRGBO(157, 131, 212, 1.0),
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              )),
          new SettingRow(
            style: globals.settingsStyle,
            rowData: SettingsDropDownConfig(
                title: 'User Area',
                initialKey: widget.country,
                choices: {
                  'Ireland': 'Ireland',
                  'United Kingdom': 'United Kingdom',
                }),
            onSettingDataRowChange: onSearchAreaChange,
            config: SettingsRowConfiguration(
                showAsTextField: false,
                showTitleLeft: !_titleOnTop,
                showTopTitle: _titleOnTop,
                showAsSingleSetting: false),
          ),
          SizedBox(height: _titleOnTop ? 10.0 : 0.0),
          new SettingRow(
            style: globals.settingsStyle,
            rowData: SettingsSliderConfig(
              title: 'Age',
              from: 18,
              to: 110,
              initialValue: widget.age,
              justIntValues: true,
              unit: ' years',
            ),
            onSettingDataRowChange: (double resultVal) {
              setState(() {
                globals.settingsChanged = true;
              });
              DatabaseService(uid: userId).enterUserAge(resultVal.toInt());
            },
            config: SettingsRowConfiguration(
                showAsTextField: false,
                showTitleLeft: !_titleOnTop,
                showTopTitle: _titleOnTop,
                showAsSingleSetting: false),
          ),
          SizedBox(height: _titleOnTop ? 10.0 : 0.0),
          new SettingRow(
            style: globals.settingsStyle,
            rowData: SettingsSliderConfig(
              title: 'Weight',
              from: 40,
              to: 120,
              initialValue: widget.weight.toDouble(),
              justIntValues: true,
              unit: ' kg',
            ),
            onSettingDataRowChange: (double resultVal) {
              setState(() {
                globals.settingsChanged = true;
              });
              DatabaseService(uid: userId).enterUserWeight(resultVal.toInt());
            },
            config: SettingsRowConfiguration(
                showAsTextField: false,
                showTitleLeft: !_titleOnTop,
                showTopTitle: _titleOnTop,
                showAsSingleSetting: false),
          ),
          SizedBox(height: _titleOnTop ? 10.0 : 0.0),
        ],
      ),
    );

    final accountSettingsTile = new Material(
      color: Colors.transparent,
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Text(intakeError),
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.fromLTRB(25.0, 5.0, 25.0, 5.0),
                child: const Text(
                  'Account',
                  style: TextStyle(
                    color: Color.fromRGBO(157, 131, 212, 1.0),
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                )),
              Padding(
                padding: const EdgeInsets.only(left: 40.0, top: 0.0),
                child: Text(
                  intakeError,
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),
          ]),
          SizedBox(height: _titleOnTop ? 10.0 : 0.0),
          Container(
            width: 600,
            height: 60,
            child: Row(
              children: [
                Container(
                    padding: EdgeInsets.fromLTRB(25.0, 5.0, 25.0, 5.0),
                    width: 225,
                    child: Text("Daily Kcal Intake Target (1500-5000)",
                style: TextStyle(
                  fontSize: 20,
                ))),
                Container(
                width: 20,
                child: GestureDetector(
                    child: Icon(Icons.help),
                  onTap: () => showPopUp("Target Calorie Intake", "The recommended daily calorie intake is 2500-3000 calories"
                      " for a man and 2000-2500 calories for a woman. This is the amount that should be consumed to maintain your current weight."
                      " In order to lose weight, you should be in a slight calorie deficit (burning more calories "
                      "than you are eating)."),
                ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(25.0, 0.0, 0.0, 0.0),
                    width: 140,
                    child: TextField(
                      // inputFormatters: [FilteringTextInputFormatter.allow(RegExp("^[0-9]")),],
                      onChanged: (text) async {
                        int value = int.parse(text);
                        if (value >= 1500) {
                          if (value <= 5000) {
                            setState(() {
                              intakeError = "";
                            });
                            globals.settingsChanged = true;
                            DatabaseService(uid: userId).updateKcalIntakeTarget(int.parse(text));
                          }

                        } else {
                          setState(() {
                            intakeError = "Enter value in range 1500-5000";
                              // globals.showSnackBar(context, "Error", "Please enter a value in the range [1500, 5000]");
                          });
                        }
                      },
                      controller: intakeController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: widget.intakeTarget.toInt().toString(),
                      ),
                    ),
                ),
              ],
            ),
          ),

          SizedBox(height: 10.0),
          Container(
            width: 600,
            height: 60,
            child: Row(
              children: [
                Container(
                    padding: EdgeInsets.fromLTRB(25.0, 5.0, 25.0, 5.0),
                    width: 225,
                    child: Text("Daily Kcal Output Target (500-3000)",
                        style: TextStyle(
                          fontSize: 20,
                        ))),
                Container(
                    width: 20,
                    child: GestureDetector(
                      child: Icon(Icons.help),
                      onTap: () => showPopUp("Calorie Output Target", "The body burns a certain amount of calories each day even if you don't exercise."
                          " You can find your resting metabolic rate online and calculate this figure. This target should be the amount of calories you"
                          " want to burn through exercise throughout the day. In order to lose weight, you should be burning slightly more than you are"
                          " consuming.")
                    ),
                ),
                Container(
                  width: 140,
                  padding: EdgeInsets.fromLTRB(25.0, 0.0, 0.0, 0.0),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    // inputFormatters: [new WhitelistingTextInputFormatter(RegExp("[a-zA-Z ]")),],
                    onChanged: (text) async {
                      int value = int.parse(text);
                      if (value >= 500) {
                        if(value <= 3000) {
                          setState(() {
                            intakeError = "";
                          });
                          globals.settingsChanged = true;
                          DatabaseService(uid: userId).updateKcalOutputTarget(int.parse(text));
                        }

                      } else {
                        setState(() {
                          intakeError = "Enter value in range 1500-5000";
                          // globals.showSnackBar(context, "Error", "Please enter a value in the range [1500, 5000]");
                        });
                      }
                    },
                    controller: outputController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: widget.outputTarget.toInt().toString(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10.0),
          new SettingRow(
            style: globals.settingsStyle,
            rowData: SettingsDropDownConfig(
                title: 'Daily Water Intake Target',
                initialKey: widget.country,
                choices: {
                  '2': '2 litres',
                  '2.5': '2.5 litres',
                  '3': '3 litres',
                  '3.5': '3.5 litres',
                  '4': '4 litres',
                  '4.5': '4.5 litres',
                  '5': '5 litres',
                  '5.5': '5.5 litres',
                  '6': '6 litres',
                }),
            onSettingDataRowChange: (double resultVal) {
              setState(() {
                globals.settingsChanged = true;
              });
              DatabaseService(uid: userId).updateWaterIntakeTarget(resultVal.toInt());
            },
            config: SettingsRowConfiguration(
                showAsTextField: false,
                showTitleLeft: !_titleOnTop,
                showTopTitle: _titleOnTop,
                showAsSingleSetting: false),
          ),
        ],
      ),
    );

    final modifyProfileTile = new Material(
        color: Colors.transparent,
        child: new Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Padding(
                  padding: EdgeInsets.fromLTRB(25.0, 5.0, 25.0, 5.0),
                  child: const Text(
                    'Profile Options',
                    style: TextStyle(
                      color: CupertinoColors.systemBlue,
                      fontWeight: FontWeight.bold,
                      fontSize: 15.0,
                    ),
                  )),
              SettingRow(
                rowData: SettingsButtonConfig(
                  title: 'Delete Profile',
                  tick: true,
                  functionToCall: () {},
                ),
                style: const SettingsRowStyle(
                    backgroundColor: CupertinoColors.lightBackgroundGray),
                config: SettingsRowConfiguration(
                    showAsTextField: false,
                    showTitleLeft: !_titleOnTop,
                    showTopTitle: _titleOnTop,
                    showAsSingleSetting: false),
              )
            ]));

    final List<Widget> widgetList = [
      profileSettingsTile,
      const SizedBox(height: 15.0),
      accountSettingsTile,
      // const SizedBox(height: 15.0),
      // legalStuff,
      // const SizedBox(height: 15.0),
      // Row(children: [Expanded(child: modifyProfileTile)]),
    ];

    return ListView(
        children: widgetList,
        physics: const AlwaysScrollableScrollPhysics());
  }
}
// new SettingRow(
//   style: globals.settingsStyle,
//   rowData: SettingsTextFieldConfig(
//     title: 'Daily Kcal Intake Target',
//     initialValue: widget.intakeTarget.toString(),
//     unit: ' kcal',
//   ),
//   onSettingDataRowChange: (String resultVal) {
//     setState(() {
//       globals.settingsChanged = true;
//     });
//     int result = int.parse(resultVal);
//     DatabaseService(uid: userId).updateKcalIntakeTarget(result);
//   },
//   config: SettingsRowConfiguration(
//       showAsTextField: false,
//       showTitleLeft: !_titleOnTop,
//       showTopTitle: _titleOnTop,
//       showAsSingleSetting: false),
// ),
// new SettingRow(
//   style: globals.settingsStyle,
//   rowData: SettingsTextFieldConfig(
//     title: 'Daily Kcal Output Target',
//     textInputType: TextInputType.text,
//     initialValue: '2500',
//     unit: ' kcal',
//   ),
//   onSettingDataRowChange: (String resultVal) {
//     setState(() {
//       globals.settingsChanged = true;
//     });
//     int result = int.parse(resultVal);
//     DatabaseService(uid: userId).updateKcalOutputTarget(result);
//   },
//   config: SettingsRowConfiguration(
//       showAsTextField: false,
//       showTitleLeft: !_titleOnTop,
//       showTopTitle: _titleOnTop,
//       showAsSingleSetting: false),
// ),