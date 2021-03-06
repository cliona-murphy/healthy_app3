import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:healthy_app/screens/home/settings_page.dart';
import 'package:healthy_app/screens/home/wrapper.dart';
import 'package:healthy_app/services/auth.dart';
import 'package:healthy_app/services/database.dart';
import 'package:healthy_app/shared/ConstantVars.dart';
import 'package:provider/provider.dart';
import 'calendar.dart';
import '../food_diary_screen/foodDiary.dart';
import '../activity_diary_screen/activityDiary.dart';
import '../medication_tracker_screen/medicationTracker.dart';
import '../nutrient_screen/nutrientChecklist.dart';
import '../progress_screen/progress.dart';
import 'package:healthy_app/shared/globals.dart' as globals;
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// ignore: must_be_immutable
class Home extends StatefulWidget {
  String date;
  Home({ this.date});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();
  final FirebaseAuth auth = FirebaseAuth.instance;
  PageController _pageController = PageController();
  List<Widget> _screens = [
    Progress(), FoodDiary(), ActivityDiary(), NutrientChecklist(), MedicationTracker(),
  ];
  int _selectedIndex = 0;
  String selectedDate = "";
  bool newDate = false;
  String userId = "";

  void initState() {
    super.initState();
    getUid();
    print("initState date = " + widget.date.toString());
    newDate = globals.newDateSelected;
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

  void _onPageChanged(int index){
    setState(() {
      _selectedIndex = index;
    });
  }

  int getSelectedIndex(){
    return _selectedIndex;
  }

  void _onItemTapped(int selectedIndex){
    _pageController.jumpToPage(selectedIndex);
    setState(() {
      _selectedIndex = selectedIndex;
    });
  }

  void renderCalendar() async {
    final result = await
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CalendarView(),
        ));
    if (result != null) {
      if (result.isNotEmpty) {
        setState(() {
          selectedDate = result;
          newDate = true;
          globals.selectedDate = selectedDate;
        });
      }
    }
  }

  renderSettingsPage() async {
    final result = await
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SettingsPage(),
        ));
    if (result.isNotEmpty) {
      print(result);
      if (result == "true") {
        showSnackBarUpdate();
      }
    }
  }

  showSnackBarUpdate() {
    return Flushbar(
      duration: Duration(seconds: 2),
      flushbarPosition: FlushbarPosition.TOP,
      title: 'Success',
      message: "Your settings were successfully updated!",
    )..show(context);
  }

  Widget build(BuildContext context){
    return StreamProvider.value(
        value: DatabaseService(uid: userId).allFoods,
        child: StreamProvider.value(
          value: DatabaseService(uid: userId).activities,
          child: StreamProvider.value(
            value: DatabaseService(uid: userId).getLoggedNutrients(),
            child: StreamProvider.value(
              value: DatabaseService(uid: userId).getLoggedMedications(),
              child: StreamProvider.value(
                value: DatabaseService(uid: userId).settings,
                child: StreamProvider.value(
                  value: DatabaseService(uid: userId).nutrientContent,
                  child: StreamProvider.value(
                    value: DatabaseService(uid: userId).medications,
                    child: StreamProvider.value(
                      value: DatabaseService(uid: userId).entryDates,
                      child: Scaffold(
                      appBar: AppBar(
                        leading: GestureDetector(
                          onTap: () {
                            renderCalendar();
                          },
                          child: Icon(
                            Icons.calendar_today_outlined,
                          ),
                        ),
                        title: newDate ? new Text(globals.selectedDate) : new Text(getCurrentDate()),
                        centerTitle: true,
                        actions: <Widget>[
                          PopupMenuButton<String>(
                            onSelected: choiceAction,
                            itemBuilder: (BuildContext context){
                              return ConstantVars.choices.map((String choice){
                                return PopupMenuItem<String>(
                                  value: choice,
                                  child: Text(choice),
                                );
                              }).toList();
                            }
                            ,)],
                      ),
                      backgroundColor: Colors.white,
                      body: PageView(
                        controller: _pageController,
                        children: _screens,
                        physics: NeverScrollableScrollPhysics(),
                      ),
                        bottomNavigationBar: BottomNavigationBar(
                          backgroundColor: globals.bottomNavigationBarColor,
                          selectedItemColor: Colors.white,
                          unselectedItemColor: Colors.white54,
                        onTap: _onItemTapped,
                        type: BottomNavigationBarType.fixed,
                        items: <BottomNavigationBarItem>[
                          BottomNavigationBarItem(
                            icon: Icon(FontAwesomeIcons.chartArea),
                                // color: getSelectedIndex() == 0 ? Colors.blue: Colors.grey),
                            label: 'Progress',
                          ),
                          BottomNavigationBarItem(
                            icon: Icon(FontAwesomeIcons.utensils),
                            label: 'Food',
                          ),
                          BottomNavigationBarItem(
                            icon: Icon(FontAwesomeIcons.running),
                            label: 'Activity',
                          ),
                          BottomNavigationBarItem(
                            icon: Icon(FontAwesomeIcons.tasks),
                            label: 'Nutrients',
                          ),
                          BottomNavigationBarItem(
                            icon: Icon(FontAwesomeIcons.pills),
                            label: 'Meds',
                          ),
                        ],
                        currentIndex: _selectedIndex,
                      ),
                   ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        // ),
    );
  }
  void choiceAction(String choice){
    if(choice == ConstantVars.Settings){
      renderSettingsPage();
      print('Settings');
    }
    else if(choice == ConstantVars.SignOut){
      _auth.signOut();
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Wrapper(),
          ));
      }
      print('SignOut');
  }

  String getCurrentDate(){
    var date = new DateTime.now().toString();
    var dateParse = DateTime.parse(date);
    var formattedDate = "${dateParse.day}/${dateParse.month}/${dateParse.year}";
    return formattedDate;
  }
}