import 'package:flutter/material.dart';
import'package:healthy_app/shared/globals.dart' as globals;

const textInputDecoration =  InputDecoration(
  fillColor: Colors.white,
  filled: true,
  enabledBorder: OutlineInputBorder(
  borderSide: BorderSide(color: Colors.grey, width: 2.0)
  ),
  focusedBorder: OutlineInputBorder(
  borderSide: BorderSide(color:  Color(0xFF151026), width: 2.0)
  ),
);
