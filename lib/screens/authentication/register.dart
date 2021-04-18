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
  String email = "";
  String password = "";
  String error = "";

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        elevation: 0.0,
        title: Text("Sign up to Healthy App"),
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.person),
            label: Text("Sign in"),
            onPressed: () {
              widget.toggleView();
            },
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
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
                    // val.isEmpty ? "Enter an email" : null,
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
                      else if (!val.contains(RegExp("[A-Z0-9]!.,{}@?/"))){
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
                SizedBox(height: 20.0),
                RaisedButton(
                    color: Colors.black,
                    child: Text(
                      "Register",
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState.validate()){
                        setState(() => loading = true);
                        dynamic result = await _auth.registerWithEmail(email, password);
                        if (result == null) {
                          setState(() {
                            error  = "please supply valid email";
                            loading = false;
                          });
                        }
                      }
                    }
                ),
                SizedBox(height: 12.0, width: 600),
                Text(
                  error,
                  style: TextStyle(
                    color: Colors.red,
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

