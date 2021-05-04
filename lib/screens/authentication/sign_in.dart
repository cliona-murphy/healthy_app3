import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:healthy_app/services/auth.dart';
import 'package:healthy_app/shared/constants.dart';
import 'package:healthy_app/shared/loading.dart';
import 'package:healthy_app/shared/globals.dart' as globals;

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
      //Color.fromRGBO(194, 148, 214, 1.0),
      body: Container(
        child: Card(
        color: Color.fromRGBO(194, 148, 214, 1.0),
        margin: new EdgeInsets.fromLTRB(7, 35, 7, 15),
        shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
        ),
          child: Column(
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(padding: EdgeInsets.only(top:60)),
              Text("LOGIN",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
                fontFamily: "Arial",
              ),
              ),
              Padding(padding: EdgeInsets.only(top:25)),
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                  padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 30.0),
                          TextFormField(
                              decoration: textInputDecoration.copyWith(hintText: "email"),
                              validator: (val) => val.isEmpty ? "Enter an email" : null,
                            onChanged: (val) {
                              setState(() => email = val);
                            }
                          ),
                          SizedBox(height: 30.0),
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
                            width: 450,
                            height: 50,
                            child: RaisedButton(
                              focusColor: Colors.grey[600],
                              color: Colors.black,
                              child: Text(
                                "LOGIN",
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
                                    color: Colors.white,
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
            ),
            ]),
        ),
      ),
    );
  }
}
