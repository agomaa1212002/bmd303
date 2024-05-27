import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';

class themeservise{
 final _box = GetStorage();
 final _Key ='isDarkMode';
 _savethemetobox(bool isDarkMode)=>_box.write(_Key,isDarkMode);
 bool _loadthemeFrombBox()=> _box.read(_Key)??false;
 ThemeMode get theme=> _loadthemeFrombBox()?ThemeMode.dark:ThemeMode.light;
 void swiththeme(){
  Get.changeThemeMode( _loadthemeFrombBox()?ThemeMode.light:ThemeMode.dark);
  _savethemetobox(!_loadthemeFrombBox());
 }
}