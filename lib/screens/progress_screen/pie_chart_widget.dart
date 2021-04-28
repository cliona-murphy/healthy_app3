import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:healthy_app/models/food.dart';
import 'package:healthy_app/models/pie_data.dart';
import 'package:healthy_app/shared/loading.dart';
import 'package:provider/provider.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:healthy_app/models/settings.dart';

class PieChart extends StatefulWidget {

  final int data;
  final int target;

  PieChart({ this.data, this.target });

  @override
  _PieChartState createState() => _PieChartState();
}

class _PieChartState extends State<PieChart> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  int totalCalories = 0;
  List<charts.Series<PieData, String>> _pieData;
  String userId = "";
  dynamic data;
  bool loading = true;

  updateBoolean(){
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        loading = false;
      });
    });
  }

  void initState() {
    super.initState();
    updateBoolean();
    getUid();
    _pieData = List<charts.Series<PieData, String>>();
  }

  Future<String> getUid() async {
    final FirebaseUser user = await auth.currentUser();
    final uid = user.uid;
    setState(() {
      userId = uid;
    });
    return uid;
  }

  generateData(int consumed) {
    double percentageIntake;
    if(consumed == 0){
      percentageIntake = .1;
    }
    else {
      percentageIntake = calculatePercentage();
      if(percentageIntake >= 100) percentageIntake = 99.99;
    }

    var piedata = [
      new PieData('Complete', percentageIntake),
      new PieData('Remaining', 100 - percentageIntake),
    ];

    _pieData.add(
      charts.Series(
        domainFn: (PieData data, _) => data.activity,
        measureFn: (PieData data, _) => data.time,
        id: 'Percentage Complete',
        data: piedata,
        labelAccessorFn: (PieData row, _) => '${row.activity}',
      ),
    );
    return _pieData;
  }

  double calculatePercentage() {
    double kcalTarget = widget.target.toDouble();
    double percentage = (widget.data.toDouble() / kcalTarget);

    setState(() {
      totalCalories = 0;
    });

    return (percentage * 100);
  }
  @override
  Widget build(BuildContext context) {
    if (widget.data != 0) {
      return Container(
        width: 150,
        height: 150,
        child: charts.PieChart(
          generateData(500),
          animate: true,
          animationDuration: Duration(milliseconds: 500),
    ));
    } else {
      return Container(
        width: 150,
        height: 150,
        //child: Text("test"),
        child: charts.PieChart(
          generateData(0),
          animate: true,
          animationDuration: Duration(milliseconds: 500),
          // defaultRenderer: new charts.ArcRendererConfig(arcWidth: 60),
        ),
      );
    }
  }
}