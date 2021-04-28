import 'package:charts_flutter/flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:healthy_app/models/bar_chart_model.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:healthy_app/shared/globals.dart' as globals;

class MyBarChart extends StatefulWidget {

  final List<BarChartModel> data;

  MyBarChart({ this.data });
  @override
  _MyBarChartState createState() => _MyBarChartState();
}

class _MyBarChartState extends State<MyBarChart> {
  String chartText;

  void initState () {
    super.initState();
    if (globals.selectedDate == globals.getCurrentDate()) {
      setState(() {
        chartText = "Today";
      });
    } else {
      setState(() {
        chartText = "on ${globals.selectedDate}";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<charts.Series<BarChartModel, String>> series = [
      charts.Series(
          id: "Progress",
          data: widget.data,
          domainFn: (BarChartModel series, _) => series.year,
          measureFn: (BarChartModel series, _) => series.financial,
          colorFn: (BarChartModel series, _) => series.color,
      )];

      return Container(
        height: 600,
        padding: EdgeInsets.all(20),
        child: Card(
          child: Padding(
          padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
              Text(
              "Percentage of Targets Hit ${chartText}",
              style: TextStyle(
                fontSize: 17,
              ),

              ),
              Expanded(
                child: Container(
                  height: 400,
                    child: charts.BarChart(
                      series,
                      animate: true,
                      behaviors: [
                        new charts.PercentInjector(
                            totalType: charts.PercentInjectorTotalType.series)
                      ],
                      primaryMeasureAxis: new charts.PercentAxisSpec(),
                    )),
            )
          ],
          ),
        ),
      ),
    );
  }
}
