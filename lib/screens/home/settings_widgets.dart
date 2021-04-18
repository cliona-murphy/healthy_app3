import 'package:cupertino_setting_control/cupertino_setting_control.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:healthy_app/services/database.dart';

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


  void initState() {
    super.initState();
    getUid();
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
    });
    DatabaseService(uid: userId).enterUserCountry(_searchAreaResult);
  }

  void pushChangesToDatabase(){

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
                  color: CupertinoColors.systemBlue,
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                ),
              )),
          new SettingRow(
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
            rowData: SettingsSliderConfig(
              title: 'Age',
              from: 18,
              to: 120,
              initialValue: widget.age,
              justIntValues: true,
              unit: ' years',
            ),
            onSettingDataRowChange: (double resultVal) {
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
            rowData: SettingsSliderConfig(
              title: 'Weight',
              from: 40,
              to: 120,
              initialValue: widget.weight.toDouble(),
              justIntValues: true,
              unit: ' kg',
            ),
            onSettingDataRowChange: (double resultVal) {
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
          const Padding(
              padding: EdgeInsets.fromLTRB(25.0, 5.0, 25.0, 5.0),
              child: const Text(
                'Account',
                style: TextStyle(
                  color: CupertinoColors.systemBlue,
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                ),
              )),
          SizedBox(height: _titleOnTop ? 10.0 : 0.0),
          new SettingRow(
            rowData: SettingsSliderConfig(
              title: 'Daily Calorie Intake Target',
              from: 1500,
              to: 5000,
              initialValue: widget.intakeTarget.toDouble(),
              justIntValues: true,
              unit: ' kcal',
            ),
            onSettingDataRowChange: (double resultVal) {
              DatabaseService(uid: userId).updateKcalIntakeTarget(resultVal.toInt());
            },
            config: SettingsRowConfiguration(
                showAsTextField: false,
                showTitleLeft: !_titleOnTop,
                showTopTitle: _titleOnTop,
                showAsSingleSetting: false),
          ),
          SizedBox(height: _titleOnTop ? 10.0 : 0.0),
          new SettingRow(
            rowData: SettingsSliderConfig(
              title: 'Daily Calorie Output Target',
              from: 1000,
              to: 4000,
              initialValue: widget.outputTarget.toDouble(),
              justIntValues: true,
              unit: ' kcal',
            ),
            onSettingDataRowChange: (double resultVal) {
              DatabaseService(uid: userId).updateKcalOutputTarget(resultVal.toInt());
            },
            config: SettingsRowConfiguration(
                showAsTextField: false,
                showTitleLeft: !_titleOnTop,
                showTopTitle: _titleOnTop,
                showAsSingleSetting: false),
          ),
          SizedBox(height: _titleOnTop ? 10.0 : 0.0),
          new SettingRow(
            rowData: SettingsSliderConfig(
              title: 'Daily Water Intake Target',
              from: 2,
              to: 5,
              initialValue: widget.waterTarget.toDouble(),
              justIntValues: true,
              unit: ' litres',
            ),
            onSettingDataRowChange: (double resultVal) {
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
      // titleOnTopSwitch,
      // const SizedBox(height: 15.0),
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
