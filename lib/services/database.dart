import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:healthy_app/models/activity.dart';
import 'package:healthy_app/models/food.dart';
import 'package:healthy_app/models/logged_nutrient.dart';
import 'package:healthy_app/models/nutrient.dart';
import 'package:healthy_app/models/settings.dart';
import 'package:healthy_app/models/medication.dart';
import 'package:healthy_app/models/medication_checklist.dart';
import 'package:healthy_app/shared/globals.dart' as globals;

class DatabaseService {

  final String uid;
  var docId;
  var documentId;
  DatabaseService ({this.uid});

  //collection reference
  final CollectionReference userCollection = Firestore.instance.collection('users');
  final CollectionReference settingsCollection = Firestore.instance.collection('settings');
  final CollectionReference entryCollection = Firestore.instance.collection('entries');
  final CollectionReference foodCollection = Firestore.instance.collection('foods');

  //creating new document in user collection for user with id = uid
  Future addUser(String email) async {
    //creating a new document in collection for user with id = uid
    return await userCollection.document(uid).setData({
      'email': email,
    });
  }
  
  Future updateUserData(int kcalIntakeTarget, int kcalOutputTarget, double waterIntakeTarget) async {
    //creating a new document in collection for user with id = uid
    return await settingsCollection.document(uid).setData({
      'kcalIntakeTarget': kcalIntakeTarget,
      'kcalOutputTarget': kcalOutputTarget,
      'waterIntakeTarget': waterIntakeTarget,
    });
  }

  Stream<DocumentSnapshot> get testUserSettings {
    return settingsCollection.document(uid)
        .snapshots();
  }

  //get userSettings Stream
  Stream<QuerySnapshot> get settings {
    return settingsCollection.snapshots();
  }

  Stream<List<Settings>> get userSettings {
    return  Firestore.instance
        .collection("settings")
    //.document(uid)
        .snapshots()
        .map(settingsListFromSnapshot);
  }

  List<Settings> settingsListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Settings(
        kcalInput: doc.data['kcalIntakeTarget'] ?? 0,
        kcalOutput: doc.data['kcalOutputTarget'] ?? 0,
        targetWater: doc.data['waterIntakeTarget'] ?? 0.0,
      );
    }).toList();
  }
  //entering user profile info
  Future enterUserCountry(String country) async {
    return await settingsCollection.document(uid).updateData({
      'country': country,
    });
  }

  Future enterUserAge(int age) async {
    return await settingsCollection.document(uid).updateData({
      'age': age,
    });
  }

  Future enterUserWeight(int weight) async {
    return await settingsCollection.document(uid).updateData({
      'weight': weight,
    });
  }

  Future updateKcalIntakeTarget(int kcal) async {
    return await settingsCollection.document(uid).updateData({
      'kcalIntakeTarget': kcal,
    });
  }

  Future updateKcalOutputTarget(int kcal) async {
    return await settingsCollection.document(uid).updateData({
      'kcalOutputTarget': kcal,
    });
  }

  Future updateWaterIntakeTarget(int water) async {
    return await settingsCollection.document(uid).updateData({
      'waterIntakeTarget': water,
    });
  }

  Future deleteAccount() async {
   //needs to be developed
  }

  //entry creation
  Future createNewEntry(String date) async {
    //creating a new document in collection for user with id = uid
    var entryName = reformatDate(getCurrentDate());
    return await Firestore.instance.collection('users')
        .document(uid)
        .collection('entries')
        .document(entryName)
        .setData({
      'entryDate': date,
    });
  }

  //food
  Future addNewFood(String foodName, int calories, String mealId, String date) async {
    //creating a new document in collection for user with id = uid
    await Firestore.instance.collection("users")
        .document(uid)
        .collection("entries")
        .where('entryDate', isEqualTo: date)
        .getDocuments()
        .then((querySnapshot) {
          print(querySnapshot.documents);
          querySnapshot.documents.forEach((result) {
            docId = result.documentID;
           });
        });
    var entryName = reformatDate(getCurrentDate());
    return await Firestore
        .instance
        .collection('users')
        .document(uid)
        .collection('entries')
        .document(entryName)
        .collection('foods')
        .document(foodName)
        .setData({
      'foodName': foodName,
      'calories': calories,
      'mealId': mealId,
    });
  }

  Future addWater(int quantity, String date) async {
    var entryName;
    if (globals.selectedDate != getCurrentDate()){
      entryName = reformatDate(globals.selectedDate);
    } else {
      entryName = reformatDate(getCurrentDate());
    }
    return await Firestore
        .instance
        .collection('users')
        .document(uid)
        .collection('entries')
        .document(entryName)
        .collection('foods')
        .document('water')
        .setData({
      'quantity': quantity,
    });
  }
  // Stream<QuerySnapshot> get water {
  //   var entryName = reformatDate(getCurrentDate());
  //   return Firestore.instance
  //       .collection("users")
  //       .document(uid)
  //       .collection('entries')
  //       .document(entryName)
  //       .collection('foods')
  //       .where('mealId', isEqualTo: 'breakfast')
  //       .snapshots();
  //
  //       //.map(foodListFromSnapshot);
  // }
  Stream<List<Food>> get allFoods {
    var entryName;
    if (globals.selectedDate != getCurrentDate()){
      entryName = reformatDate(globals.selectedDate);
    } else {
      entryName = reformatDate(getCurrentDate());
    }
    return Firestore.instance
        .collection('users')
        .document(uid)
        .collection('entries')
        .document(entryName)
        .collection('foods')
        .snapshots()
        .map(foodListFromSnapshot);
  }

  Stream<List<Food>> get breakFastFoods {
    //check if entry exists before trying to retrieve it?
    var entryName;
    if (globals.selectedDate != getCurrentDate()){
      entryName = reformatDate(globals.selectedDate);
    } else {
      entryName = reformatDate(getCurrentDate());
    }
    return Firestore.instance
        .collection("users")
        .document(uid)
        .collection('entries')
        .document(entryName)
        .collection('foods')
         .where('mealId', isEqualTo: 'breakfast')
        .snapshots()
      .map(foodListFromSnapshot);
    }

  Stream<List<Food>> get lunchFoods {
    var entryName;
    if (globals.selectedDate != getCurrentDate()){
      entryName = reformatDate(globals.selectedDate);
    } else {
      entryName = reformatDate(getCurrentDate());
    }
    return Firestore.instance
        .collection("users")
        .document(uid)
        .collection('entries')
        .document(entryName)
        .collection('foods')
        .where('mealId', isEqualTo: 'lunch')
        .snapshots()
        .map(foodListFromSnapshot);
  }

  Stream<List<Food>> get dinnerFoods {
    var entryName;
    if (globals.selectedDate != getCurrentDate()){
      entryName = reformatDate(globals.selectedDate);
    } else {
      entryName = reformatDate(getCurrentDate());
    }
    return Firestore.instance
        .collection("users")
        .document(uid)
        .collection('entries')
        .document(entryName)
        .collection('foods')
        .where('mealId', isEqualTo: 'dinner')
        .snapshots()
        .map(foodListFromSnapshot);
  }

  Stream<List<Food>> get snacks {
    var entryName;
    if (globals.selectedDate != getCurrentDate()){
      entryName = reformatDate(globals.selectedDate);
    } else {
      entryName = reformatDate(getCurrentDate());
    }
    return Firestore.instance
        .collection("users")
        .document(uid)
        .collection('entries')
        .document(entryName)
        .collection('foods')
        .where('mealId', isEqualTo: 'snack')
        .snapshots()
        .map(foodListFromSnapshot);
  }

    //food list from a snapshot
  List<Food> foodListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Food(
        foodName: doc.data['foodName'] ?? '',
        calories: doc.data['calories'] ?? 0,
        mealId: doc.data['mealId'] ?? '',
      );
    }).toList();
  }

  updateFoodDetails(String foodName, int calories) async {
    var entryName;
    if (globals.selectedDate != getCurrentDate()){
      entryName = reformatDate(globals.selectedDate);
    } else {
      entryName = reformatDate(getCurrentDate());
    }
    return await Firestore.instance.collection('users')
        .document(uid)
        .collection('entries')
        .document(entryName)
        .collection('foods')
        .document(foodName)
        .updateData({
      'foodName': foodName,
      'calories': calories,
    });
  }

  deleteFood(foodName) async {
    var entryName;
    if (globals.selectedDate != getCurrentDate()){
      entryName = reformatDate(globals.selectedDate);
    } else {
      entryName = reformatDate(getCurrentDate());
    }
    return await Firestore.instance.collection('users')
        .document(uid)
        .collection('entries')
        .document(entryName)
        .collection('foods')
        .document(foodName)
        .delete();
  }

  //medication
  Future addMedication(String medName, String time) async {
    return await Firestore.instance.collection('users')
        .document(uid)
        .collection('medications')
        .document(medName)
        .setData({
      'medicationName': medName,
      'timeToTake': time,
    });
  }

  Stream<List<Medication>> get medications {
    return  Firestore.instance
        .collection("users")
        .document(uid)
        .collection('medications')
        .snapshots()
        .map(medicationListFromSnapshot);
  }

  List<Medication> medicationListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Medication(
        medicineName: doc.data['medicationName'] ?? '',
        timeToTake: doc.data['timeToTake'] ?? '',
      );
    }).toList();
  }

  medTaken(String medName, bool checked) async {
    var entryName;
    if (globals.selectedDate != getCurrentDate()){
      entryName = reformatDate(globals.selectedDate);
    } else {
      entryName = reformatDate(getCurrentDate());
    }
    return await Firestore.instance.collection('users')
        .document(uid)
        .collection('entries')
        .document(entryName)
        .collection('medChecklist')
        .document(medName)
        .setData({
      'medicationName': medName,
      'taken': checked,
      'timeTaken': getCurrentTime(),
    });
  }

  updateMedicationDetails(String originalMedName, String newMedName, String timeToTake) async {
    await Firestore.instance.collection('users')
        .document(uid)
        .collection('medications')
        .document(originalMedName)
        .delete();
    return await Firestore.instance.collection('users')
        .document(uid)
        .collection('medications')
        .document(newMedName)
        .updateData({
      'medicationName': newMedName,
      'timeToTake': timeToTake,
    });
  }

  updateMedicationTime(String medName, String timeToTake) async {
    return await Firestore.instance.collection('users')
        .document(uid)
        .collection('medications')
        .document(medName)
        .updateData({
      'medicationName': medName,
      'timeToTake': timeToTake,
    });
  }

  updateTimeTaken(String medName) async {
    return await Firestore.instance.collection('users')
        .document(uid)
        .collection('medications')
        .document(medName)
        .updateData({
      'timeTaken': getCurrentTime(),
    });
  }
  //this function works if the med name has not been previously edited
  deleteMedication(String medName) async {
    return await Firestore.instance.collection('users')
        .document(uid)
        .collection('medications')
        .document(medName)
        .delete();
  }
  Stream<List<MedicationChecklist>> getLoggedMedications() {
    var entryName;
    if (globals.selectedDate != getCurrentDate()){
      entryName = reformatDate(globals.selectedDate);
    } else {
      entryName = reformatDate(getCurrentDate());
    }
    return Firestore.instance.collection('users')
        .document(uid)
        .collection('entries')
        .document(entryName)
        .collection('medChecklist')
        .snapshots()
        .map(medicationChecklistFromSnapshot);
  }

  List<MedicationChecklist> medicationChecklistFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return MedicationChecklist(
        medicineName: doc.data['medicationName'] ?? '',
        taken: doc.data['taken'] ?? '',
        timeTaken: doc.data['timeTaken'] ?? '',
      );
    }).toList();
  }

  Stream<List<Nutrient>> get nutrientContent {
    return  Firestore.instance
        .collection("checklist")
        .snapshots()
        .map(nutrientListFromSnapshot);
  }

  List<Nutrient> nutrientListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Nutrient(
        id: doc.data['id'] ?? 0,
        tileContent: doc.data['content'] ?? 0,
        hintText: doc.data['hintText'] ?? 0,
      );
    }).toList();
  }

  checkNutrientTile(String id, bool checked) async {
      var entryName;
      if (globals.selectedDate != getCurrentDate()){
        entryName = reformatDate(globals.selectedDate);
      } else {
        entryName = reformatDate(getCurrentDate());
      }
      return await Firestore.instance.collection('users')
          .document(uid)
          .collection('entries')
          .document(entryName)
          .collection('nutrientChecklist')
          .document(id)
          .setData({
        'id': id,
        'taken': checked,
      });
    }

  Stream<List<LoggedNutrient>> getLoggedNutrients() {
    var entryName;
    if (globals.selectedDate != getCurrentDate()){
      entryName = reformatDate(globals.selectedDate);
    } else {
      entryName = reformatDate(getCurrentDate());
    }
    return Firestore.instance.collection('users')
        .document(uid)
        .collection('entries')
        .document(entryName)
        .collection('nutrientChecklist')
        .snapshots()
        .map(loggedNutrientListFromSnapshot);
  }


  List<LoggedNutrient> loggedNutrientListFromSnapshot(QuerySnapshot snapshot) {
      return snapshot.documents.map((doc) {
        return LoggedNutrient(
          id: doc.data['id'] ?? '',
          taken: doc.data['taken'] ?? false,
        );
      }).toList();
    }

  //activity diary
  Future addActivity(String activityType, double distance, double duration, double calories) async {
    var roundedDistanceString = distance.toStringAsExponential(2);
    double roundedDistance = double.parse(roundedDistanceString);
    var roundedDurationString = duration.toStringAsExponential(2);
    double roundedDuration = double.parse(roundedDurationString);
    var roundedCaloriesString = calories.toStringAsExponential(2);
    double roundedCalories = double.parse(roundedCaloriesString);

    var entryName = getEntryName();
    return await Firestore
        .instance
        .collection('users')
        .document(uid)
        .collection('entries')
        .document(entryName)
        .collection('activities')
        .add({
      'type': activityType,
      'distance': roundedDistance,
      'duration': roundedDuration,
      'calories': roundedCalories,
    });
  }

  //not working but same functionality as med checklist
  Stream<List<Activity>> get activities {
    var entryName = getEntryName();
    return  Firestore.instance
        .collection("users")
        .document(uid)
        .collection('entries')
        .document(entryName)
        .collection('activities')
        .snapshots()
        .map(activityListFromSnapshot);
  }

  List<Activity> activityListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.documents.map((doc) {
      return Activity(
        activityType: doc.data['type'] ?? '',
        distance: doc.data['distance'] ?? 0,
        duration: doc.data['duration'] ?? 0,
        calories: doc.data['calories'] ?? 0,
        docId: doc.documentID,
      );
    }).toList();
  }

  deleteActivity(String docId) async {
    var entryName = getEntryName();
    return await Firestore.instance.collection('users')
        .document(uid)
        .collection('entries')
        .document(entryName)
        .collection('activities')
        .document(docId)
        .delete();
  }

  updateActivity(String docId, String type, double distance, double duration, double calories) async {
    var entryName = getEntryName();
    return await Firestore.instance.collection('users')
        .document(uid)
        .collection('entries')
        .document(entryName)
        .collection('activities')
        .document(docId)
        .updateData({
           'type': type,
          'distance': distance,
          'duration': duration,
          'calories': calories,
    });
  }

    //misc
  String getEntryName(){
    var entryName;
    if (globals.selectedDate != getCurrentDate()){
      entryName = reformatDate(globals.selectedDate);
    } else {
      entryName = reformatDate(getCurrentDate());
    }
    return entryName;
  }
  //misc
  String getCurrentTime() {
    var time = new DateTime.now().toString();
    var timeParse = DateTime.parse(time);
    String minute = timeParse.minute.toString();
    if (timeParse.minute < 10){
      minute = "0${minute}";
    }
    var formattedTime = "${timeParse.hour}:${minute}";
    return formattedTime;
  }

  String getCurrentDate(){
    var date = new DateTime.now().toString();
    var dateParse = DateTime.parse(date);
    var formattedDate = "${dateParse.day}/${dateParse.month}/${dateParse.year}";
    return formattedDate;
  }

  String reformatDate(String date){
    var newDateArr = date.split("/");
    String newDate = "";
    newDate = newDate + newDateArr[0] + newDateArr[1] + newDateArr[2];
    return newDate;
  }
}