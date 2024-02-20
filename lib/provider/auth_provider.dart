import 'package:flutter/material.dart';
import 'package:franko_mobile_app/models/loginModel.dart';
import 'package:franko_mobile_app/util/local_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Authentication with ChangeNotifier {
  Localstorage local;

  List<UserLogin> _items;
  List<DataU> _incartItems;
  String _tokenValue;
  List<DataU> get incartItems => _incartItems;
  List<UserLogin> get items => _items;
  String get tokenValue => _tokenValue;

  Authentication() {
    local = Localstorage();
  }
  getToken() {
    SharedPreferences.getInstance()
        .then((prefs) => {_tokenValue = prefs.getString("token")});
    if(tokenValue != null){
      print(tokenValue);
    }
  }
}
