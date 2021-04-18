import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:healthy_app/services/auth.dart';
import 'package:healthy_app/shared/constants.dart';
import 'package:healthy_app/shared/loading.dart';

class SignIn extends StatefulWidget {

  final Function toggleView;
  SignIn({ this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  //text field state
  String email = "";
  String password = "";
  
  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      backgroundColor: Colors.grey[200],
      body: Column(
        children: [
          Padding(padding: EdgeInsets.only(top:50)),
          Text("Welcome Back!",
          style: TextStyle(
            //fontFamily: 'Raleway',
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
          ),
          SingleChildScrollView(
          child: Container(
          padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 20.0),
                  TextFormField(
                      decoration: textInputDecoration.copyWith(hintText: "email"),
                      validator: (val) => val.isEmpty ? "Enter an email" : null,
                    onChanged: (val) {
                      setState(() => email = val);
                    }
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                      decoration: textInputDecoration.copyWith(hintText: "password"),
                    obscureText: true,
                      validator: (val) => val.length < 6 ? "Enter a password of 6 characters or more" : null,
                    onChanged: (val) {
                      setState(() => password = val);
                    }
                  ),
                  SizedBox(height: 30.0),
                  Container(
                    width: 500,
                    height: 50,
                    child: RaisedButton(
                      focusColor: Colors.grey[600],
                      color: Colors.black,
                      child: Text(
                        "Sign in",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                      onPressed: () async {
                        if (_formKey.currentState.validate()){
                          setState(() => loading = true);
                          dynamic result = await _auth.signInWithEmail(email, password);
                          if (result == null) {
                            setState(() {
                            loading = false;
                            });
                              return Flushbar(
                                backgroundColor: Colors.red[600],
                                duration: Duration(seconds: 2),
                                flushbarPosition: FlushbarPosition.TOP,
                                title: 'Error',
                                message: "Could not sign in with those credentials.",
                              )..show(context);
                          }
                        }
                      }
                    ),
                  ),
                  Row(
                    children: [
                      Container(
                      child: Text(
                        "Don't have an account yet?",
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ),
                      TextButton(
                        child: Text("Click to sign up",
                          style: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        onPressed: () {
                          widget.toggleView();
                        },
                      ),
                  ]),
                ],
              ),
            ),
          ),
        ),
      ]),
    );
  }
}
