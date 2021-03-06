import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:healthy_app/services/database.dart';
import 'package:healthy_app/models/nutrient.dart';
import 'package:healthy_app/shared/globals.dart' as globals;

class NutrientTile extends StatefulWidget {
  final Nutrient tile;
  // final String tileContent;
  final bool taken;
  //
  NutrientTile({ this.tile, this.taken });

  @override
  _NutrientTileState createState() => _NutrientTileState();
}

class _NutrientTileState extends State<NutrientTile> {
  bool isSelected;
  final FirebaseAuth auth = FirebaseAuth.instance;

  void initState(){
    super.initState();
    setState(() {
      isSelected = widget.taken;
    });
  }

  Future<String> getUserid() async {
    final FirebaseUser user = await auth.currentUser();
    final uid = user.uid;
    return uid;
  }

  updateDatabase(String id, bool complete) async {
    String userId = await getUserid();
    DatabaseService(uid: userId).checkNutrientTile(id, complete);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Card(
        margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
        child: CheckboxListTile(
          checkColor: Colors.white,
          activeColor: globals.lightPurple,
          title: Text(widget.tile.tileContent,
            style: TextStyle(fontSize: 23.0),),
          subtitle: Text(widget.tile.hintText,
            style: TextStyle(fontSize: 17.0),
          ),
          value: isSelected,
          onChanged: (bool newValue) {
            setState(() {
              print(isSelected);
              updateDatabase(widget.tile.id, newValue);
              isSelected = newValue;
            });
          },
        ),
      ),
    );
  }
}
