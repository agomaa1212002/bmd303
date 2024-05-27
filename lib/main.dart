import 'package:firebase_core/firebase_core.dart';
import 'package:neutrition_sqlite/screens/app.dart';
import 'package:neutrition_sqlite/screens/comines.dart';
import 'package:neutrition_sqlite/screens/pateint.dart';
import 'package:neutrition_sqlite/screens/test.dart';
import 'package:neutrition_sqlite/tests/combined_dashboard.dart';
import 'package:neutrition_sqlite/tests/dachbourd.dart';
import 'package:neutrition_sqlite/tests/prescp.dart';

import 'package:neutrition_sqlite/widgets/add_task_bar.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get_storage/get_storage.dart';
import 'package:neutrition_sqlite/screens/Treatment_Plan_Page.dart';
import 'package:neutrition_sqlite/screens/gemeni.dart';
import 'package:neutrition_sqlite/screens/home_page.dart';
import 'package:neutrition_sqlite/screens/login.dart';
import 'package:neutrition_sqlite/screens/main_screen.dart';
import 'package:neutrition_sqlite/screens/myplans.dart';
import 'package:neutrition_sqlite/screens/signup.dart';
import 'package:neutrition_sqlite/screens/t_plans_mean.screen.dart';
import 'package:neutrition_sqlite/screens/theme.dart';
import 'package:neutrition_sqlite/servises/theme_servises.dart';
import 'package:neutrition_sqlite/widgets/add_druge.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'mydatabase/Test.dart';
import 'mydatabase/db_healper.dart';
import 'mydatabase/sqldb.dart';
//import 'package:sqflite_common_ffi/sqflite_ffi.dart';

import 'package:sqflite_common/sqlite_api.dart';

void main()  async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.android,
  );
  await GetStorage.init();
  // Initialize SQLite FFI bindings
  sqfliteFfiInit();

  // Set the database factory to use FFI
  databaseFactory = databaseFactoryFfi;
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Dashborad UI',
      debugShowCheckedModeBanner: false,

    theme:themes.light,
    darkTheme: themes.light,
    themeMode:themeservise().theme ,
      home:SignInPage(),
    );
  }
}
