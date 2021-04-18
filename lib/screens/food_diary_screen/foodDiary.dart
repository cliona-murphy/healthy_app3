import 'package:flutter/material.dart';
import 'package:healthy_app/models/food.dart';
import 'package:healthy_app/services/database.dart';
import 'package:healthy_app/shared/loading.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'food_list.dart';

class FoodDiary extends StatefulWidget {

  @override
  _FoodDiaryState createState() => _FoodDiaryState();
}

class _FoodDiaryState extends State<FoodDiary> {

  final FirebaseAuth auth = FirebaseAuth.instance;

  String userId = "";
  List<Food> foods = new List<Food>();
  int listLength = 0;
  bool foodLogged = false;
  bool userIdSet = false;
  bool loading = true;

  TextEditingController customController = TextEditingController();
  TextEditingController calorieController = TextEditingController();

  void initState(){
    super.initState();
    getUid();
    updateBoolean();
  }
  updateBoolean(){
    Future.delayed(const Duration(milliseconds: 1000), () {
      setState(() {
        loading = false;
      });
    });
  }
  Future <String> onContainerTapped(BuildContext context, String mealId){
    return showDialog(context: context, builder: (context) {
      return AlertDialog(
          title: Text("What did you eat?"),
          content: Container(
            height: 100,
            child : SingleChildScrollView(
              child: Column(
                children: [
                  //Text("Food name"),
                  TextField(
                    controller: customController,
                    decoration: InputDecoration(
                      hintText: "food name",
                    ),
                  ),
                  TextField(
                    controller: calorieController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: "calories",
                    ),
                  ),
                ],
              ),
            ),
          ),
        actions: <Widget> [
          MaterialButton(
              elevation: 5.0,
              child: Text("Submit"),
              onPressed: () {
                foodLogged = true;
                updateDatabase(customController.text, int.parse(calorieController.text), mealId);
                customController.clear();
                calorieController.clear();
                Navigator.pop(context);
              },
          ),
        ],
      );
   });
  }

  Future <String> onWaterContainerTapped(BuildContext context, String mealId){
    return showDialog(context: context, builder: (context) {
      return AlertDialog(
        title: Text("How much did you drink?"),
        content: Container(
          height: 60,
          child : SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: calorieController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "Enter water in ml",
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: <Widget> [
          MaterialButton(
            elevation: 5.0,
            child: Text("Submit"),
            onPressed: () {
              addWater(int.parse(calorieController.text));
              customController.clear();
              calorieController.clear();
              Navigator.pop(context);
            },
          ),
        ],
      );
    });
  }

  updateDatabase(String name, int calories, String mealId) async{
    userId = await getUid();
    if(userId != ""){
      DatabaseService(uid: userId).addNewFood(name, calories, mealId, getCurrentDate());
    }
  }

  addWater(int qty) async {
    userId = await getUid();
    DatabaseService(uid: userId).addWater(qty, getCurrentDate());
  }

   Future<String> getUid() async {
     final FirebaseUser user = await auth.currentUser();
     final uid = user.uid;
     setState(() {
       userId = uid;
     });
     setState(() {
       userIdSet = true;
     });
     print(uid);
     return uid;
  }

  String getCurrentDate(){
    var date = new DateTime.now().toString();
    var dateParse = DateTime.parse(date);
    var formattedDate = "${dateParse.day}/${dateParse.month}/${dateParse.year}";
    return formattedDate;
  }

  void rebuildAllChildren(BuildContext context) {
    void rebuild(Element el) {
      el.markNeedsBuild();
      el.visitChildren(rebuild);
    }
    (context as Element).visitChildren(rebuild);
  }

  Widget build(BuildContext context) {
    rebuildAllChildren(context);
    return loading ? Loading() : Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: new Container (
            padding: const EdgeInsets.all(30.0),
            color: Colors.white,
            child: new Container(
                child: new Column(
                  children: <Widget>[
                    Padding(padding: EdgeInsets.only(top: 0.0)),
                    Text('Breakfast',
                      style: new TextStyle(
                          color: Colors.blue, fontSize: 20.0),
                    ),
                    Padding(padding: EdgeInsets.only(top: 10.0)),
                    InkWell(
                      onTap: () {
                        onContainerTapped(context, "breakfast");
                      },
                      child: StreamProvider<List<Food>>.value(
                        value: DatabaseService(uid:userId).breakFastFoods,
                        child: Container(
                          width: 300,
                          height: 60,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.blueAccent)
                          ),
                          child: FoodList(),
                        ),
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 30.0)),
                    Text('Lunch',
                      style: new TextStyle(
                          color: Colors.blue, fontSize: 20.0),
                    ),
                    Padding(padding: EdgeInsets.only(top: 10.0)),
                    InkWell(
                      onTap: () {
                        onContainerTapped(context, "lunch");
                      },
                      child: StreamProvider<List<Food>>.value(
                        value: DatabaseService(uid:userId).lunchFoods,
                        child: Container(
                          width: 300,
                          height: 60,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.blueAccent)
                          ),
                          child: FoodList(),
                        ),
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 30.0)),
                    Text('Dinner',
                      style: new TextStyle(
                          color: Colors.blue, fontSize: 20.0),
                    ),
                    Padding(padding: EdgeInsets.only(top: 10.0)),
                    InkWell(
                      onTap: () {
                        onContainerTapped(context, "dinner");
                      },
                      child: StreamProvider<List<Food>>.value(
                          value: DatabaseService(uid:userId).dinnerFoods,
                        child: Container(
                          width: 300,
                          height: 60,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.blueAccent)
                          ),
                          child: FoodList(),
                        ),
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 30.0)),
                    Text('Snacks',
                      style: new TextStyle(
                          color: Colors.blue, fontSize: 20.0),
                    ),
                    Padding(padding: EdgeInsets.only(top: 10.0)),
                    InkWell(
                      onTap: () {
                        onContainerTapped(context, "snack");
                      },
                      child: StreamProvider<List<Food>>.value(
                          value: DatabaseService(uid:userId).snacks,
                        child: Container(
                          width: 300,
                          height: 60,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.blueAccent)
                          ),
                          child: FoodList(),
                        ),
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(top: 30.0)),
                    // Text('Water',
                    //   style: new TextStyle(
                    //       color: Colors.blue, fontSize: 20.0),
                    // ),
                    // Padding(padding: EdgeInsets.only(top: 10.0)),
                    // InkWell(
                    //   onTap: () {
                    //     onWaterContainerTapped(context, "water");
                    //   },
                    //   child: StreamProvider<List<Food>>.value(
                    //       value: DatabaseService(uid:userId).lunchFoods,
                    //     child: Container(
                    //       width: 300,
                    //       height: 60,
                    //       decoration: BoxDecoration(
                    //           border: Border.all(color: Colors.blueAccent)
                    //       ),
                    //       child: WaterTile(),
                    //     ),
                    //   ),
                    // ),
                  ]),
          ),
          ),
        ),
    );
  }
}
