import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:healthy_app/models/logged_nutrient.dart';
import 'package:healthy_app/models/nutrient.dart';
import 'package:healthy_app/screens/nutrient_screen/nutrient_list.dart';
import 'package:healthy_app/services/database.dart';
import 'package:provider/provider.dart';

class NutrientChecklist extends StatefulWidget {

  @override
  _NutrientChecklistState createState() => _NutrientChecklistState();
}

class _NutrientChecklistState extends State<NutrientChecklist> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  var userId;

  void initState() {
    super.initState();
    getUid();
  }
  Future<String> getUid() async {
    final FirebaseUser user = await auth.currentUser();
    final uid = user.uid;
    setState(() {
      userId = uid;
    });
    print(uid);
    return uid;
  }

  Widget build(BuildContext context){
    return StreamProvider<List<Nutrient>>.value(
      value: DatabaseService(uid: userId).nutrientContent,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            height: 900,
            child: Center(
              child: Column(
                  children: [
                    Padding(padding: EdgeInsets.only(top: 30.0)),
                    StreamProvider<List<LoggedNutrient>>.value(
                      value: DatabaseService(uid: userId).getLoggedNutrients(),
                      child: NutrientList(),
                    ),
                  ]),
            ),
          ),
        ),
      ),
    );
  }
}