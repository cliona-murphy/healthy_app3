import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:healthy_app/models/bar_chart_model.dart';
import 'package:charts_flutter/flutter.dart' as charts;

import 'my_bar_chart.dart';

class BarChartBuilder extends StatefulWidget {
  final int consumed;
  final int burned;
  final int nutrients;
  final int meds;
  BarChartBuilder({ this.consumed, this.burned, this.nutrients, this.meds});

  @override
  _BarChartBuilderState createState() => _BarChartBuilderState();
}

class _BarChartBuilderState extends State<BarChartBuilder> {
  List<BarChartModel> data;

  @override
  void initState() {
    super.initState();

    data = [
      BarChartModel(
        year: "Consumed",
        financial: widget.consumed == 0 ? 1 : widget.consumed,
        color: charts.ColorUtil.fromDartColor
          (Color(0xFF47505F)),
      ),
      BarChartModel(
        year: "Burned",
        financial: widget.burned == 0 ? 1 : widget.burned,
        color: charts.ColorUtil.fromDartColor
          (Colors.red),
      ),
      BarChartModel(
        year: "Nutrients",
        financial: widget.nutrients == 0 ? 1 : widget.nutrients,
        color: charts.ColorUtil.fromDartColor
          (Colors.green),
      ),
      BarChartModel(
        year: "Meds",
        financial: widget.meds == 0 ? 1 : widget.meds,
        color: charts.ColorUtil.fromDartColor
          (Colors.yellow),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 400,
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            child: Card(
              child: MyBarChart(data: data),
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.all(16.0),
          //   child: Center(
          //     child: Text(
          //       'Number of Mobile App Downloads in past 3 years (Data Source: Statista)',
          //       textAlign: TextAlign.center,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}