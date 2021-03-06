import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:healthy_app/models/food.dart';
import 'package:healthy_app/services/database.dart';
import 'package:healthy_app/shared/globals.dart' as globals;

class FoodTile extends StatefulWidget {

  final Food food;
  FoodTile({ this.food});

  @override
  _FoodTileState createState() => _FoodTileState();
}

class _FoodTileState extends State<FoodTile> {
  TextEditingController nameController;
  TextEditingController calorieController = TextEditingController();

  final FirebaseAuth auth = FirebaseAuth.instance;

  void initState() {
    super.initState();
    nameController = new TextEditingController(); //text: widget.food.foodName
  }


  Future<String> getUserid() async {
    final FirebaseUser user = await auth.currentUser();
    final uid = user.uid;
    return uid;
  }

  updateDetails(String foodName, int calories) async {
    String userId = await getUserid();
    DatabaseService(uid: userId).updateFoodDetails(
        widget.food.docId, foodName, calories);
  }

  // updateBothDetails() async {
  //   String userId = await getUserid();
  //   DatabaseService(uid: userId).updateFoodDetails(widget.food.docId, foodName, calories);
  // }
  deleteFood(String foodName) async {
    String userId = await getUserid();
    DatabaseService(uid: userId).deleteFood(widget.food.docId);
  }

  String validateNameEntry(String value) {
    if (value.isEmpty) {
      return "Please enter a valid food name";
    }
    return null;
  }

  String validateCalorieEntry(String value) {
    print(value);
    if (value.isEmpty) {
      return "Please enter a valid value for calories";
    }
    return null;
  }

  showConfirmationDialog(BuildContext context) {
    print("here");
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = FlatButton(
        child: Text("Confirm"),
        onPressed: () {
          deleteFood(widget.food.foodName);
          Navigator.pop(context);
          Navigator.pop(context);
        }
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Confirm Action"),
      content: Text("Do you want to delete " + widget.food.foodName + "?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Future<String> editItem(BuildContext context, String foodName, int calories) {
    setState(() {
      nameController.text = widget.food.foodName;
      calorieController.text = widget.food.calories.toString();
    });
    return showDialog(context: context, barrierDismissible: false, builder: (context) {
      return AlertDialog(
        title: Text("Edit the details for '${widget.food.foodName}' here:", textAlign: TextAlign.left),
        content: Container(
          height: 110,
          child : SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: "food name",
                    // errorText: validateNameEntry(nameController.text),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0),
                ),
                TextFormField(
                  controller: calorieController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    //hintText: widget.food.calories.toString(),
                    hintText: "calories",
                    errorText: validateCalorieEntry(calorieController.text),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: <Widget> [
          MaterialButton(
            elevation: 5.0,
            child: Text("Cancel"),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            //elevation: 5.0,
            color: Colors.red,
            onPressed: () {
              showConfirmationDialog(context);
            },
          ),
          MaterialButton(
            elevation: 5.0,
            child: Text("Update"),
            onPressed: () {
              if(nameController.text.isNotEmpty && calorieController.text.isNotEmpty){
                updateDetails(nameController.text, int.parse(calorieController.text));
              } else if(nameController.text.isNotEmpty){
                updateDetails(nameController.text, widget.food.calories);
              } else if (calorieController.text.isNotEmpty){
                updateDetails(widget.food.foodName, int.parse(calorieController.text));
              }
              nameController.clear();
              calorieController.clear();
              Navigator.pop(context);
              globals.showSnackBar(context , "Success!", "Your food was successfully updated!");
            },
          ),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: IconButton(
          icon: Icon(Icons.edit),
          onPressed: (){
            editItem(context, widget.food.foodName, widget.food.calories);
            setState(() {
            });
          },
        ),
        title: Text(widget.food.foodName,
        style: TextStyle(
          fontSize: 20,
        ),
        ),
        subtitle: Text("${widget.food.calories.toString()} calories",
          style: TextStyle(
            fontSize: 15,
          ),
        ),
      );
  }
}
