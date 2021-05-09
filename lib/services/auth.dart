import 'package:firebase_auth/firebase_auth.dart';
import 'package:healthy_app/models/user.dart';
import 'package:healthy_app/services/database.dart';
import 'package:healthy_app/shared/globals.dart' as globals;

class AuthService {

    final FirebaseAuth _auth = FirebaseAuth.instance;
    //create user obj based on FirebaseUser
    User _userFromFirebaseUser(FirebaseUser user){
      return user != null ? User(uid: user.uid) : null;
    }

    // auth change user stream
    Stream<User> get user {
      return _auth.onAuthStateChanged
        .map(_userFromFirebaseUser);
    }

    //anon sign-in
Future signInAnon() async {
  try {
    AuthResult result = await _auth.signInAnonymously();
    FirebaseUser user = result.user;
    return _userFromFirebaseUser(user);
  } catch(e) {
    print(e.toString());
    return null;
  }
}
//sign out
Future signOut() async {
      try {
        return await _auth.signOut();
      } catch(e) {
        print(e.toString());
        return null;
      }
}

Future registerWithEmail(String email, String password, String fName, String sName) async {
      try {
        AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
        FirebaseUser user = result.user;
        //create userSettings document for the new user
        await DatabaseService(uid: user.uid).addUser(email);
        await DatabaseService(uid: user.uid).updateUserData(fName, sName, 18, 60, 'Ireland', 2500, 0, 2.0);
        await DatabaseService(uid: user.uid).createNewEntry(getCurrentDate());
        return _userFromFirebaseUser(user);

      } catch(e){
        print(e.toString());
        return null;
      }
}

  Future signInWithEmail(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      FirebaseUser user = result.user;
      //create userSettings document for the new user
      //permission was denied when trying to updateUserData immediately after registering
      //likely because it was not picking up that the user was authenticated
      //so moved updateUserData to occur after user logs in, as system recognizes them as authenticated after login
      await DatabaseService(uid: user.uid).addUser(email);
      //await DatabaseService(uid: user.uid).updateUserData(2500, 2500, 2.0);
      await DatabaseService(uid: user.uid).createNewEntry(getCurrentDate());
      return _userFromFirebaseUser(user);
    } catch(e){
      print(e.toString());
      return null;
    }
  }

  String getCurrentDate(){
    var date = new DateTime.now().toString();
    var dateParse = DateTime.parse(date);
    var formattedDate = "${dateParse.day}/${dateParse.month}/${dateParse.year}";
    return formattedDate;
  }
}