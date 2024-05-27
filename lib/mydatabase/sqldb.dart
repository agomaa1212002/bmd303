// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';
// class SqlDb{
//   static Database? _db;
//   Future <Database?> get db async{
//
//     if (_db ==null){
//       _db = await intialDb();
//       return _db;
//
//   }else{
//       return _db;
//     }
//   }
//
//   intialDb() async{
//     String databasepath = await getDatabasesPath();
//     String path = join(databasepath,'mydb.db');
//     Database mydb = await openDatabase(path, onCreate: _onCreat, version:11, onUpgrade: _onUpgrade ,);
//     return mydb ;
//
//   }
//   _onUpgrade(Database db , int version, int newversion )async{
//  print(" on Upgrade======================================================");
//  await db.execute("ALTER TABLE notes ADD COLUMN title TEXT");
//   }
//   _onCreat(Database db, int version)async{
//    Batch batch = db.batch() ;
//  //   batch.execute('''
//  //  CREATE TABLE "notes"(
//  // "id" INTEGER  NOT NULL PRIMARY KEY,
//  //  "note" TEXT NOT NULL
//  //  )
//  //  ''');
//    batch.execute('''
//   CREATE TABLE "Users"(
//  "id" INTEGER  NOT NULL PRIMARY KEY,
//   "name" TEXT NOT NULL,
//   "email" TEXT NOT NULL,
//   "password" TEXT NOT NULL
//   )
//   ''');
//    batch.execute('''
//   CREATE TABLE "task"(
//   "id" INTEGER PRIMARY KEY AUTOINCREMENT,
//   "title" TEXT NOT NULL,
//   "note" TEXT NOT NULL,
//   "isCompleted" INTEGER NOT NULL,
//   "date" TEXT NOT NULL,
//   "startTime" TEXT NOT NULL,
//   "endTime" TEXT NOT NULL,
//   "color" INTEGER NOT NULL,
//
//   )
//   ''');
//
//    await batch.commit();
//
// print("create DATABASE SND TABLE ======================================");
//
//   }
//   readData(String sql) async{
//     Database? mydb = await db ;
//     List<Map> response = await  mydb!.rawQuery(sql);
//     return response ;
//   }
//   insertData(String sql) async{
//     Database? mydb = await db ;
//      int response = await  mydb!.rawInsert(sql);
//     return response ;
//   }
//   updateData(String sql) async{
//     Database? mydb = await db ;
//     int response = await  mydb!.rawUpdate(sql);
//     return response ;
//   }
//   deleteData(String sql) async{
//     Database? mydb = await db ;
//     int response = await  mydb!.rawDelete(sql);
//     return response ;
//   }
//   mydeleteDatabase()async{
//     String databasepath = await getDatabasesPath();
//     String path = join(databasepath,'mydb.db');
//     await deleteDatabase(path);
//   }
//
// }
