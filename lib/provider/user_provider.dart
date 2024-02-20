import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider with ChangeNotifier {
  final String localUserStorageKey = 'user_personal_data';
  final String resetPasswordKey = 'validate_code_key';
  // var _userDetails;
  var details;
  var _userInfo;
  bool _routeToValidateCode;
  bool get routeTovalidateCode => _routeToValidateCode;

  get userInfo => _userInfo;

  Future<SharedPreferences> _prefs;

  UserProvider() {
    _prefs = SharedPreferences.getInstance();
  }

  resetPasswordState() async {
    SharedPreferences prefs = await _prefs;
    prefs.setBool(resetPasswordKey, false);
  }

  obtainRouteState() async {
    SharedPreferences prefs = await _prefs;
    _routeToValidateCode = prefs.getBool(resetPasswordKey);
    notifyListeners();
  }

  newPasswordConfirmed() async {
    SharedPreferences prefs = await _prefs;
    await prefs.setBool(resetPasswordKey, false);
    notifyListeners();
  }

  saveUserDetails(value) async {
    SharedPreferences prefs = await _prefs;
    print(value.toString() + 'value in saved prefs ');
    await prefs.setString(localUserStorageKey, json.encode(value));
    print('saved user prefs');
    var item = prefs.get(localUserStorageKey);
    print(item.toString() + "get prefs in saved");
    notifyListeners();
  }

  loadUserDetails() {
    getDetails();
    notifyListeners();
  }

  getDetails() async {
    await _getUserDetails().then((value) => {
          details = value,
          _userInfo = value,
          print(details.toString() + 'user provider load details')
        });
  }

  Future _getUserDetails() async {
    final SharedPreferences prefs = await _prefs;
    var items = await json.decode(prefs.getString(localUserStorageKey));
    _userInfo = items;
    print(items);
    print('items--user pro');
    notifyListeners();
    return items;
  }

  clearUserDetails() {
  
  }
}
