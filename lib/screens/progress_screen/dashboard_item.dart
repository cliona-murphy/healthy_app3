import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:healthy_app/models/food.dart';
import 'package:healthy_app/screens/progress_screen/pie_chart_widget.dart';
import 'package:healthy_app/shared/loading.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

import 'calorie_count.dart';

class DashboardItem extends StatefulWidget {
  final String title;
  final String data;
  final String units;
  final int target;

  DashboardItem({this.title, this.data, this.units, this.target});

  @override
  _DashboardItemState createState() => _DashboardItemState();
}

class _DashboardItemState extends State<DashboardItem> {
  double percentageIntakeValue = 0;
  String percentage = "";
  bool loading = true;

  void initState (){
    super.initState();
    loading = true;
    if (widget.target != 0) {
      percentageIntakeValue = (int.parse(widget.data)) / widget.target;
    } else {
      percentageIntakeValue = 0.0;
    }
    updateBoolean();
  }

  updateBoolean() {
    Future.delayed(const Duration(milliseconds: 1000), () {
      setState(() {
        loading = false;
      });
    });
  }

  double calculatePercentage(){
    if (widget.target != 0) {
      percentageIntakeValue = ((int.parse(widget.data)) / widget.target);
    } else {
      percentageIntakeValue = 0.0;
    }
    return percentageIntakeValue;
  }

  String convertPercentageToString(){
    double value = percentageIntakeValue*100;
    var roundedValueString = value.toStringAsExponential(2);
    double roundedValue = double.parse(roundedValueString);
    String result = roundedValue.toString();
    return result;
  }

  @override
  Widget build(BuildContext context) {
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
                SizedBox(height: 5.0),
                PieChart(data: int.parse(widget.data), target: widget.target,),
                Center(
                    child: Text("${convertPercentageToString()}%",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),)
                ),
                SizedBox(height: 5.0),
                Center(
                    child: Text("${widget.data} ${widget.units}",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),)
                ),
                new Center(
                  child: new Text(widget.title,
                      style:
                      new TextStyle(fontSize: 18.0, color: Colors.black)),
                )
              ],
            ),
          ),
        ));
  }
}
