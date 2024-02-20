import 'package:flutter/material.dart';
import 'package:franko_mobile_app/models/cities.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddressProvider with ChangeNotifier {

  String _regionDropdownData;
  String get regionDropdownData => _regionDropdownData;

  Cities _cityDropdownData;
  Cities get cityDropdownData => _cityDropdownData;

  Future<SharedPreferences> _prefs;


  AddressProvider(){
    _prefs = SharedPreferences.getInstance();
    
  }

  





}
