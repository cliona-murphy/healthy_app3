import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:healthy_app/models/food.dart';
import 'package:provider/provider.dart';
import 'package:healthy_app/screens/food_diary_screen/food_tile.dart';

class FoodList extends StatefulWidget {
  @override
  _FoodListState createState() => _FoodListState();
}

class _FoodListState extends State<FoodList> {
  @override
  Widget build(BuildContext context) {
    bool foodsNull = false;
    final foods = Provider.of<List<Food>>(context) ?? [];

    if(foods.isNotEmpty){
      return RawScrollbar(
        thumbColor: Colors.blueAccent,
        radius: Radius.circular(20),
        thickness: 5,
        child: ListView.builder(
          itemCount: foods.length,
          itemBuilder: (context, index) {
            return FoodTile(food: foods[index]);
          },
        ),
      );
    } else {
      return Container(
        height: 80,
        width: 320,
        padding: const EdgeInsets.fromLTRB(30, 10, 30, 15),
        child: Column(
          children: [
            Text('What did you eat?',
            textAlign: TextAlign.center,
            style: new TextStyle(
                color: Colors.grey, fontSize: 20.0),
          ),
            Text('Click to log a food.',
              textAlign: TextAlign.center,
              style: new TextStyle(
                  color: Colors.grey, fontSize: 20.0),
            ),
            // Text('You can log multiple foods.',
            //   textAlign: TextAlign.center,
            //   style: new TextStyle(
            //       color: Colors.grey, fontSize: 15.0),
            // ),
        ]),
      );
    }
  }
}
