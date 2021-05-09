import 'package:charts_flutter/flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:healthy_app/models/bar_chart_model.dart';
import 'package:healthy_app/models/logged_nutrient.dart';
import 'package:healthy_app/models/medication.dart';
import 'package:healthy_app/models/nutrient.dart';
import 'package:healthy_app/models/pie_data.dart';
import 'package:healthy_app/models/settings.dart';
import 'package:healthy_app/screens/progress_screen/bar_chart_builder.dart';
import 'package:healthy_app/screens/progress_screen/calorie_count.dart';
import 'package:healthy_app/services/auth.dart';
import 'package:healthy_app/models/food.dart';
import 'package:healthy_app/services/database.dart';
import 'package:healthy_app/shared/globals.dart';
import 'package:healthy_app/shared/loading.dart';
import 'package:provider/provider.dart';
import 'package:healthy_app/models/activity.dart';
import 'package:healthy_app/models/medication_checklist.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'dashboard_item.dart';
import 'package:fl_chart/fl_chart.dart' as charts2;

class Progress extends StatefulWidget {

  @override
  _ProgressState createState() => _ProgressState();
}

class _ProgressState extends State<Progress> {
  final AuthService _auth = AuthService();
  final FirebaseAuth auth = FirebaseAuth.instance;
  bool loading;
  String userId = "";

  void initState() {
    super.initState();
    loading = true;
    getUid();
    updateBoolean();

  }

  updateBoolean() {
    Future.delayed(const Duration(milliseconds: 1000), () {
      setState(() {
        loading = false;
      });
    });
  }

  Future<String> getUid() async {
    final FirebaseUser user = await auth.currentUser();
    final uid = user.uid;
    setState(() {
      userId = uid;
    });
    return uid;
  }

  int calculatePercentage(int integer, int total){
    double percentage = 0;
    if (total != 0) {
      percentage = (integer / total);
    } else {
      percentage = 0.0;
    }
    double value = percentage*100;
    var roundedValueString = value.toStringAsExponential(2);
    double roundedValue = double.parse(roundedValueString);
    return roundedValue.toInt();
  }

  Widget build(BuildContext context) {
    final foods = Provider.of<List<Food>>(context) ?? [];
    final activities = Provider.of<List<Activity>>(context) ?? [];
    final loggedNutrients = Provider.of<List<LoggedNutrient>>(context) ?? [];
    final nutrients = Provider.of<List<Nutrient>>(context) ?? [];
    final loggedMedications = Provider.of<List<MedicationChecklist>>(context) ?? [];
    final medications = Provider.of<List<Medication>>(context) ?? [];
    var totalCaloriesConsumed = 0;
    var totalCaloriesBurned = 0;
    var noLoggedNutrients = 0;
    var totalNutrients = 0;
    var noLoggedMedications = 0;
    var totalMedications = 0;

    if (foods.isNotEmpty) {
      for (var food in foods)
        totalCaloriesConsumed += food.calories;
    }
    if (activities.isNotEmpty) {
      for (var activity in activities) {
        totalCaloriesBurned += activity.calories.toInt();
      }

    }
    if (loggedNutrients.isNotEmpty) {
      for (var nutrient in loggedNutrients)
        if(nutrient.taken){
          noLoggedNutrients++;
        }
    }
    if (nutrients.isNotEmpty) {
      for (var nutrient in nutrients)
        totalNutrients++;
    }
    if (loggedMedications.isNotEmpty) {
      for (var med in loggedMedications)
        if(med.taken){
          noLoggedMedications++;
        }
    }
    if (medications.isNotEmpty) {
      for (var med in medications)
        totalMedications++;
    }

    return StreamBuilder(
        stream: Firestore.instance.collection('settings')
            .document(userId)
            .snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          int targetIntake;
          int targetOutput;
          if (snapshot.hasData) {
            targetIntake = snapshot.data['kcalIntakeTarget'].toInt();
            targetOutput = snapshot.data['kcalOutputTarget'].toInt();
          } else {
            targetIntake = 2500;
            targetOutput = 2500;
          }
          return loading ? Loading() : Scaffold(
            body: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                  padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 2.0),
                    child: Column(
                      children: [
                        Row(
                        children: [
                          Expanded(
                            child: DashboardItem(title: "Consumed", data: totalCaloriesConsumed.toString(), units: "kcal", target: targetIntake, route: '/food'),
                          ),
                          Expanded(
                            child: DashboardItem(title: "Burned", data: totalCaloriesBurned.toString(), units:"kcal", target: targetOutput, route: '/activity',),
                          ),
                        ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: DashboardItem(title: "Checked", data: noLoggedNutrients.toString(), units: noLoggedNutrients != 1 ? "nutrients" : "nutrient", target: totalNutrients, route: '/nutrients'),
                            ),
                            Expanded(
                              child: DashboardItem(title: "Taken", data: noLoggedMedications.toString(), units: noLoggedMedications != 1 ? "medications" : "medication", target: totalMedications, route: '/medications'),
                            ),
                          ],
                        ),
                        // Container(
                        //   height: 400,
                        //   child: BarChartBuilder(
                        //     consumed: calculatePercentage(totalCaloriesConsumed, targetIntake),
                        //     burned: calculatePercentage(totalCaloriesBurned, targetOutput),
                        //     nutrients: calculatePercentage(noLoggedNutrients, totalNutrients),
                        //     meds: calculatePercentage(noLoggedMedications, totalMedications),
                        //   ),
                        // ),
                    ])
                  ),
                ]),
              ),
            );
          });
    }
  }