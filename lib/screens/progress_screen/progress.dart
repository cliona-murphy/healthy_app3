import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:healthy_app/models/settings.dart';
import 'package:healthy_app/screens/progress_screen/calorie_count.dart';
import 'package:healthy_app/services/auth.dart';
import 'package:healthy_app/models/food.dart';
import 'package:healthy_app/services/database.dart';
import 'package:healthy_app/shared/loading.dart';
import 'package:provider/provider.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:healthy_app/models/pie_data.dart';
import 'package:healthy_app/shared/globals.dart' as globals;
import 'package:healthy_app/models/activity.dart';

import '../food_diary_screen/food_list.dart';
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

  Card makeDashboardItem(String title, String data) {
    return Card(
        elevation: 1.0,
        margin: new EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(color: Color.fromRGBO(220, 220, 220, 1.0)),
          child: new InkWell(
            onTap: () {},
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              verticalDirection: VerticalDirection.down,
              children: <Widget>[
                SizedBox(height: 50.0),
                Center(
                    child: Text("1000",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),)
                ),
                // child: Icon(
                //   icon,
                //   size: 40.0,
                //   color: Colors.black,
                // )),
                SizedBox(height: 20.0),
                new Center(
                  child: new Text(title,
                      style:
                      new TextStyle(fontSize: 18.0, color: Colors.black)),
                )
              ],
            ),
          ),
        ));
  }

  Widget build(BuildContext context) {
    final foods = Provider.of<List<Food>>(context) ?? [];
    final activities = Provider.of<List<Activity>>(context) ?? [];
    var totalCaloriesConsumed = 0;
    var totalCaloriesBurned = 0;
    if (foods.isNotEmpty) {
      for (var food in foods)
        totalCaloriesConsumed += food.calories;
    }
    if (activities.isNotEmpty) {
      for (var activity in activities)
        totalCaloriesBurned += activity.calories.toInt();
    }
      return StreamBuilder(
          stream: Firestore.instance.collection('settings')
              .document(userId)
              .snapshots(),
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            var target;
            if (snapshot.hasData) {
              //if (snapshot.data['kcalIntakeTarget'])
              target = snapshot.data['kcalIntakeTarget'];
            } else {
              target = 2000;
            }
            return Container(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 2.0),
              child: GridView.count(
                crossAxisCount: 2,
                padding: EdgeInsets.all(3.0),
                children: <Widget>[
                  DashboardItem(title: "Consumed", data: totalCaloriesConsumed.toString(), units: "kcal"),
                  DashboardItem(title: "Burned", data: totalCaloriesBurned.toString(), units:"kcal"),
                  DashboardItem(title: "Checked", data: "alarm", units: "items"),
                  DashboardItem(title: "Taken", data: "alarm", units: ""),
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