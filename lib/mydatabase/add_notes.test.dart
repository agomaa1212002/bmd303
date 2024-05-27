// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:neutrition_sqlite/mydatabase/sqldb.dart';
//
// import '../widgets/input_field.dart';
//
// class AddNotes extends StatefulWidget {
//   const AddNotes({super.key});
//
//   @override
//   State<AddNotes> createState() => _AddNotesState();
// }
//
// class _AddNotesState extends State<AddNotes> {
//   SqlDb sqlDb =SqlDb();
//   final TextEditingController TitleController= TextEditingController();
//   final TextEditingController NoteController = TextEditingController();
//   final TextEditingController colorController = TextEditingController();
//   GlobalKey<FormState> formstate = GlobalKey();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Add notes"),
//       ),
//       body:Container(child: Padding(
//
//         padding: const EdgeInsets.all(10),
//         child: ListView(children:
//         [
//          Form(
//              key:formstate,
//              child:
//          Column(
//            children: [
//              TextFormField(
//                controller: NoteController,
//                decoration: InputDecoration(
//                  hintText: "note"
//                ),
//              )
//             , TextFormField(
//                controller: TitleController,
//                decoration: InputDecoration(
//                    hintText: "title"
//                ),
//              ),
//              TextFormField(
//                controller: colorController,
//                decoration: InputDecoration(
//                    hintText: "color"
//                ),
//              ),
//              Container(height: 20,),
//            MaterialButton(onPressed:() async {
//           int response= await sqlDb.insertData('''
//           INSERT INTO notes ("note", "title","color")
//           VALUES("${NoteController.text}","${TitleController.text}","${colorController.text}")
//           '''
//           );
//           print("response========================") ;
//           if (response > 0){
//             Get.back();
//           }
//
//            },
//
//             textColor: Colors.white,
//             color: Colors.blue
//            ,child: Text('Add note'),
//            )],
//
//          ))
//         ],),
//       ),));
//   }
// }
