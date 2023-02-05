

import 'package:flutter/material.dart';

class GlobalConfig extends ChangeNotifier{
  String _user_name = "QianYu";

  String get user_name => _user_name;

  set user_name(String value) {
    _user_name = value;
  }
}