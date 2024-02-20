import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';



class Localstorage {
  
  final String token = "franko_token";


   Future<SharedPreferences> _prefs;

Localstorage(){
  _prefs = SharedPreferences.getInstance();
}


  addSecurityToken(String key, String value) async{
     final SharedPreferences prefs = await _prefs;
       prefs.setString(key, value);
  }

  deleteSecurityToken(String value) async{
    final SharedPreferences prefs = await _prefs;
    await prefs.remove(value);
  }

  Future<String>getSecurityToken(String value) async{
     final SharedPreferences prefs = await _prefs;
         prefs.getString(value);
    if(value == null){
       json.decode(value = '0');
    }else{
      //json.decode(value);
    }
    return value;
  }
}