import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:healthy_app/services/auth.dart';
import 'package:healthy_app/shared/constants.dart';
import 'package:healthy_app/shared/loading.dart';

class Register extends StatefulWidget {

  final Function toggleView;
  Register({ this.toggleView});

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;

  //text field state
  String fName = "";
  String sName = "";
  String email = "";
  String password = "";
  String error = "";

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      backgroundColor: Colors.grey[200],
      body: Container(
        child: Card(
        color: Color.fromRGBO(194, 148, 214, 1.0),
        margin: new EdgeInsets.fromLTRB(7, 35, 7, 15),
        shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
        ),
          child: Column(
            children: [
            Padding(padding: EdgeInsets.only(top:50)),
            Text("REGISTER",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ),
              Padding(padding: EdgeInsets.only(top:20)),
             Expanded(
               child: Container(
                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
                child: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 20.0),
                        TextFormField(
                            decoration: textInputDecoration.copyWith(hintText: "first name"),
                            validator: (val) {
                              if (val.isEmpty){
                                return "Enter your name";
                              } else if (val.contains(RegExp("[0-9!.,{}@?/]"))) {
                                return "Please supply a valid name";
                              }
                              else {
                                return null;
                              }
                            },
                            onChanged: (val) {
                              setState(() => fName = val);
                            }
                        ),
                        SizedBox(height: 20.0),
                        TextFormField(
                            decoration: textInputDecoration.copyWith(hintText: "surname"),
                            validator: (val) {
                              if (val.isEmpty){
                                return "Enter your name";
                              } else if (val.contains(RegExp("[0-9!.,{}@?/]"))) {
                                return "Please supply a valid name";
                              }
                              else {
                                return null;
                              }
                            },
                            onChanged: (val) {
                              setState(() => sName = val);
                            }
                        ),
                        SizedBox(height: 20.0),
                        TextFormField(
                          decoration: textInputDecoration.copyWith(hintText: "email"),
                          validator: (val) {
                            if (val.isEmpty){
                              return "Enter an email";
                            } else if (!val.contains(RegExp("@"))) {
                              return "Please supply a valid email";
                            }
                            else {
                              return null;
                            }
                          },
                            onChanged: (val) {
                              setState(() => email = val);
                            }
                        ),
                        SizedBox(height: 20.0),
                        TextFormField(
                            decoration: textInputDecoration.copyWith(hintText: "password"),
                            validator: (val) {
                              if (val.length < 6) {
                                return "Enter a password of 6 character or more";
                              }
                              else if (!val.contains(RegExp("[A-Z0-9!.,{}@?/]"))){
                                return "Include a capital letter, digit and special character.";
                              }
                              else {
                                return null;
                              }
                            },
                            obscureText: true,
                            onChanged: (val) {
                              setState(() => password = val);
                            }
                        ),
                        SizedBox(height: 30.0),
                        Container(
                          width: 500,
                          height: 50,
                          child: RaisedButton(
                              color: Colors.black,
                              child: Text(
                                "REGISTER",
                                style: TextStyle(color: Colors.white, fontSize: 20),
                              ),
                              onPressed: () async {
                                if (_formKey.currentState.validate()){
                                  setState(() => loading = true);
                                  dynamic result = await _auth.registerWithEmail(email, password, fName, sName);
                                  if (result == null) {
                                    setState(() {
                                      error  = "please supply valid email";
                                      loading = false;
                                    });
                                  }
                                }
                              }
                          ),
                        ),
                        Center(
                          child: Row(
                              children: [
                                Container(
                                  child: Text(
                                    "    Already have an account?",
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                TextButton(
                                  child: Text("Click to login",
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
                        ),
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

