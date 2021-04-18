import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:healthy_app/models/food.dart';
import 'package:provider/provider.dart';
import 'package:healthy_app/screens/food_diary_screen/food_tile.dart';

class WaterTile extends StatefulWidget {
  @override
  _WaterTileState createState() => _WaterTileState();
}

class _WaterTileState extends State<WaterTile> {
  @override
  Widget build(BuildContext context) {
    bool foodsNull = false;
    final water = Provider.of<QuerySnapshot>(context) ?? [];

    //if(foods != null){
    // if(water.isNotEmpty){
    //   print("foods list is not null");
    //   print("length of list = " + water.length.toString());
    //   return ListView.builder(
    //     //scrollDirection: Axis.horizontal,
    //     itemCount: water.length,
    //     itemBuilder: (context, index) {
    //       return ListTile(
    //         title: Text(water.quantity),
    //        // subtitle: Text("${widget.food.calories.toString()} calories"),
    //       );
    //     },
    //   );
    // } else {
    //   return Container(
    //     height: 80,
    //     width: 300,
    //     padding: const EdgeInsets.fromLTRB(30, 20, 30, 15),
    //     child: Text('Click to log water',
    //       textAlign: TextAlign.center,
    //       style: new TextStyle(
    //           color: Colors.grey, fontSize: 15.0),
    //     ),
    //   );
    //}
  }
}
