// import 'dart:developer';
//
// import 'package:sqflite/sqflite.dart';
//
// import '../model/Task.dart';
// class DbHelper {
//   static Database? _db;
//   static final int _versoin = 10;
//   static String _mydb = "appointment";
//
//
//   static Future<void> initDb() async {
//     if (_db != null) {
//       return;
//     }
//     try {
//       String _path = await getDatabasesPath() + 'nu.db';
//       log(_path.toString());
//       _db = await openDatabase(
//         _path,
//         version: _versoin,
//         onCreate: (db, version) {
//           print("creating a new one");
//           return db.execute(
//             "CREATE TABLE $_mydb("
//                 "id INTEGER PRIMARY KEY AUTOINCREMENT,"
//                 "title TEXT NOT NULL,"
//                 "note TEXT NOT NULL,"
//                 "isCompleted INTEGER NOT NULL,"
//                 "date TEXT NOT NULL,"
//                 "startTime TEXT NOT NULL,"
//                 "endTime TEXT NOT NULL,"
//                 "color INTEGER NOT NULL"
//                 ")",
//           );
//         },
//
//       );
//     } catch (e) {
//       print("Error initializing database: $e");
//       // Handle initialization error, maybe throw an exception or log it.
//     }
//   }
//
//    Future<int> insert(Task? task) async {
//     print("insert function called");
//     return await _db?.insert(_mydb, task!.toJson()) ?? 1;
//   }
//
//    Future<List<Map<String, dynamic>>> query() async {
//     try {
//       if (_db == null) {
//         throw Exception("Database is not initialized.");
//       }
//       print("query function called");
//       return _db!.query(_mydb);
//     } catch (e) {
//       print("Error querying database: $e");
//       return []; // Return an empty list or handle the error as needed.
//     }
//   }
// }