import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:healthy_app/models/food.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

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

  void initState (){
    super.initState();
    percentageIntakeValue = (int.parse(widget.data)) / widget.target;
    print("hi" + percentageIntakeValue.toString());
  }

  double calculatePercentage(){
    percentageIntakeValue = ((int.parse(widget.data)) / widget.target);

    print("hi" + percentageIntakeValue.toString());
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
                SizedBox(height: 20.0),
                new CircularPercentIndicator(
                  radius: 80.0,
                  lineWidth: 10.0,
                  percent: calculatePercentage(),
                  center: new Text("${convertPercentageToString()}%"),
                  progressColor: Colors.green,
                ),
                Center(
                    child: Text("${widget.data} ${widget.units}",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),)
                ),
                SizedBox(height: 10.0),
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
