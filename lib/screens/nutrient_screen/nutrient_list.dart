import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:healthy_app/models/logged_nutrient.dart';
import 'package:healthy_app/shared/loading.dart';
import 'package:provider/provider.dart';
import 'package:healthy_app/models/nutrient.dart';
import 'package:healthy_app/screens/nutrient_screen/nutrient_tile.dart';

class NutrientList extends StatefulWidget {
  @override
  _NutrientListState createState() => _NutrientListState();
}

class _NutrientListState extends State<NutrientList> {
  bool loading = true;

  void initState() {
    super.initState();
    updateBoolean();
  }

  updateBoolean() {
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        loading = false;
      });
    });
  }

  bool checkIfTaken(Nutrient nutrient, List<LoggedNutrient> nutrientsLogged) {

    bool returnBool = false;
    for (var loggedNut in nutrientsLogged) {
      if (nutrient.id == loggedNut.id) {
        if (loggedNut.taken) {
          returnBool = true;
        }
      }
    }
    return returnBool;
  }

  @override
  Widget build(BuildContext context) {
    final nutrientTiles = Provider.of<List<Nutrient>>(context) ?? [];
    final loggedNutrients = Provider.of<List<LoggedNutrient>>(context) ?? [];

      return loading ? Loading() : ListView.builder(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        itemCount: nutrientTiles.length,
        itemBuilder: (context, index) {
          return NutrientTile(tile: nutrientTiles[index], taken: checkIfTaken(nutrientTiles[index], loggedNutrients));
        },
      );
  }
}


