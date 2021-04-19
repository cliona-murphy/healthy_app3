import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:healthy_app/models/food.dart';
import 'package:provider/provider.dart';

class DashboardItem extends StatefulWidget {
  final String title;
  final String data;
  final String units;
  DashboardItem({this.title, this.data, this.units});

  @override
  _DashboardItemState createState() => _DashboardItemState();
}

class _DashboardItemState extends State<DashboardItem> {
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
                SizedBox(height: 50.0),
                Center(
                    child: Text(widget.data,
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),)
                ),
                Center(
                    child: Text(widget.units,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),)
                ),
                SizedBox(height: 20.0),
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
