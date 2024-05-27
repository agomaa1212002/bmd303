
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../screens/theme.dart';

class Mybutton extends StatelessWidget {
  final String label;
  final Function()? onTap;

  const Mybutton({super.key, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Container(
            width: 100,
            height: 60,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: primaryClr
            ),
            child: Center(
              child: Text(


                label,
                style:

                TextStyle(

                    color: Colors.white),),
            )));
  }
}