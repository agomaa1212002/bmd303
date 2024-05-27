// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:neutrition_sqlite/mydatabase/sqldb.dart';
// import 'package:sqflite_common/sqflite.dart';
// import 'add_notes.test.dart';
//
//
// class Test extends StatefulWidget {
//   const Test({super.key});
//
//   @override
//   State<Test> createState() => _TestState();
// }
//
// class _TestState extends State<Test> {
//   SqlDb sqlDb = SqlDb();
//   Future<List<Map<String, dynamic>>> readData() async {
//     List<Map<String, dynamic>> response = await sqlDb.readData("SELECT * FROM notes");
//     return response;
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           "this is for testing"
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(onPressed: ()=>Get.to(AddNotes())
//       ,child: Icon(Icons.add),),
//       body: Container(
//       child:ListView(
//         children: [
//           MaterialButton(onPressed: ()async{
//       await sqlDb.mydeleteDatabase();
//
//           },child: Text('DELETE DATABASE'),),
//           FutureBuilder(builder: (BuildContext context, AsyncSnapshot<List<Map>> snapshot){
//             if (snapshot.hasData){
//               return ListView.builder(
//                 itemCount: snapshot.data!.length,
//                 physics:NeverScrollableScrollPhysics() ,
//                 shrinkWrap: true,
//                 itemBuilder: (context,i){
//                   return Card(child: ListTile(
//                 title: Text("${snapshot.data![i]["note"]}"),
//                     subtitle: Text("${snapshot.data![i]["title"]}"),
//                     trailing: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                    //      IconButton(onPressed: () async{
//                    //   int response = await sqlDb.deleteData("DELETE FROM notes WHERE id =${snapshot.data![i]["id"]}");
//                    //   if (response>0){
//                    //    Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>Test()
//                    //    ));
//                    //   }
//                    //
//                    // },
//
//                    // icon: Icon(Icons.delete),color: Colors.red,),
//                         IconButton(onPressed: (){
//
//                         },
//                       icon: Icon(Icons.edit),color: Colors.blue,),
//
//
//                         IconButton(onPressed: () async {
//                           int response = await sqlDb.deleteData("DELETE FROM notes WHERE id =${snapshot.data![i]["id"]}");
//                              if (response>0){
//                               Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>Test()
//                               ));
//                              }
//                         },
//
//                           icon: Icon(Icons.delete),color: Colors.red,),
//
//
//                       ],
//                     ),
//                     trailing: IconButton(onPressed: () async{
//                       int response = await sqlDb.deleteData("DELETE FROM notes WHERE id =${snapshot.data![i]["id"]}");
//                       if (response>0){
//                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context)=>Test()  ));
//                       }
//
//                     },
//
//                     icon: Icon(Icons.delete),color: Colors.red,),
//                   ));
//                 },);
//             };
//             return Center(child :CircularProgressIndicator() );
//           }, future: readData(),)
//         ],
//       ) ,
//       ),
//     );
//   }
// }
