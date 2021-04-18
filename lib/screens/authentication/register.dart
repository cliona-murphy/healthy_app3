import 'package:flutter/material.dart';
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
                  validator: (val) => val.isEmpty ? "Enter an email" : null,
                    onChanged: (val) {
                      setState(() => email = val);
                    }
                ),
                SizedBox(height: 20.0),
                TextFormField(
                    decoration: textInputDecoration.copyWith(hintText: "password"),
                    validator: (val) => val.length < 6 ? "Enter a password of 6 characters or more" : null,
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
                SizedBox(height: 12.0),
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

