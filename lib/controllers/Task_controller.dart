// import 'package:get/get.dart';
// import 'package:neutrition_sqlite/mydatabase/db_healper.dart';
//
// import '../model/Task.dart';
//
// class TaskController extends GetxController{
//   final Db = DbHelper();
// @override
//   void onReady(){
//   getTask();
//    super.onReady();
//
// }
// var taskList = <Task>[].obs;
// Future<int> addTask({Task? task}) async {
//  return await Db.insert(task);
// }
// void getTask() async{
//   List<Map<String,dynamic>> task = await Db.query();
//   taskList.assignAll(task.map((data) => new Task.fromjson(data)).toList());
// }
// }