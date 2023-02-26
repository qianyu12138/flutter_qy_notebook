
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CommonToast{
  static void show(String str){
    Fluttertoast.showToast(
        msg: str,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.grey,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}