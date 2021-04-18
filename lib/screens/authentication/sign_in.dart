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
  String error = "";
  
  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        elevation: 0.0,
        title: Text("Sign in to Healthy App"),
        actions: <Widget>[
          FlatButton.icon(
            icon: Icon(Icons.person),
            label: Text("Register"),
            onPressed: () {
              widget.toggleView();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
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
                SizedBox(height: 20.0),
                RaisedButton(
                  color: Colors.black,
                  child: Text(
                    "Sign in",
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    if (_formKey.currentState.validate()){
                      setState(() => loading = true);
                      dynamic result = await _auth.signInWithEmail(email, password);
                      if (result == null) {
                        setState(() {
                        error = "could not sign in with those credentials";

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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
