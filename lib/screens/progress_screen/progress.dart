import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:healthy_app/models/logged_nutrient.dart';
import 'package:healthy_app/models/medication.dart';
import 'package:healthy_app/models/nutrient.dart';
import 'package:healthy_app/models/settings.dart';
import 'package:healthy_app/screens/progress_screen/calorie_count.dart';
import 'package:healthy_app/services/auth.dart';
import 'package:healthy_app/models/food.dart';
import 'package:provider/provider.dart';
import 'package:healthy_app/models/activity.dart';
import 'package:healthy_app/models/medication_checklist.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'dashboard_item.dart';

class Progress extends StatefulWidget {

  @override
  _ProgressState createState() => _ProgressState();
}

class _ProgressState extends State<Progress> {
  final AuthService _auth = AuthService();
  final FirebaseAuth auth = FirebaseAuth.instance;
  bool loading = true;
  //var totalCalories = 0;

  String userId = "";

  void initState() {
    super.initState();
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
      for (var activity in activities)
        totalCaloriesBurned += activity.calories.toInt();
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
              targetIntake = 2000;
              targetOutput = 2000;
            }
            return Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 2.0),
              child: GridView.count(
                crossAxisCount: 2,
                padding: EdgeInsets.all(3.0),
                children: <Widget>[
                  DashboardItem(title: "Consumed", data: totalCaloriesConsumed.toString(), units: "kcal", target: targetIntake,),
                  DashboardItem(title: "Burned", data: totalCaloriesBurned.toString(), units:"kcal", target: targetOutput),
                  DashboardItem(title: "Checked", data: noLoggedNutrients.toString(), units: noLoggedNutrients != 1 ? "nutrients" : "nutrient", target: totalNutrients),
                  DashboardItem(title: "Taken", data: noLoggedMedications.toString(), units: noLoggedMedications != 1 ? "medications" : "medication", target: totalMedications),
                  // makeDashboardItem("Alphabet", Icons.alarm),
                  // makeDashboardItem("Alphabet", Icons.alarm)
                ],
              ),
            );
            // return loading ? Loading() : Scaffold(
            //   backgroundColor: Colors.white,
            //   body: Row(
            //     crossAxisAlignment: CrossAxisAlignment.stretch,
            //     children: [
            //       Expanded(
            //         child: Column(
            //           children: [
            //             Padding(padding: EdgeInsets.only(top: 15.0)),
            //             Text("Calories Consumed",
            //               style: TextStyle(
            //                   color: Colors.grey[600],
            //                   fontWeight: FontWeight.bold,
            //                   fontSize: 15),
            //             ),
            //             StreamProvider<List<Food>>.value(
            //               value: DatabaseService(uid: userId).allFoods,
            //               child: CalorieCount(calorieTarget: target),
            //             )
            //           ],
            //         ),
            //       ),
            //       Expanded(
            //         child: Column(
            //           children: [
            //             Padding(padding: EdgeInsets.only(top: 15.0)),
            //             Text("Calories Burned",
            //               style: TextStyle(
            //                   color: Colors.grey[600],
            //                   fontWeight: FontWeight.bold,
            //                   fontSize: 15),
            //             ),
            //             //This should listen to activity diary when it is developed
            //             StreamProvider<List<Food>>.value(
            //               value: DatabaseService(uid: userId).allFoods,
            //               child: CalorieCount(calorieTarget: target),
            //             )
            //           ],
            //         ),
            //       ),
            //     ],
            //   ),
            // );
          });
    }
  }