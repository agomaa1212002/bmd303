
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
const Color bluishClr =Color(0xFF4e5ae8);
const Color yellowClr =Color(0xFFFB746);
const Color pinkClr =Color(0xFFff4667);
const Color white =Colors.white;
const primaryClr = bluishClr;
const Color darkgreyClr =Color(0xFF121212);
const Color darkheaderClr =Color(0xFF424242);
const backgroundClr2 = Color(0xFF15131C);

class themes{
static final light=  ThemeData(
primaryColor: primaryClr,

brightness: Brightness.light
);


  static final dark=  ThemeData(
      primaryColor:darkgreyClr,
      brightness: Brightness.dark,



  );
}
TextStyle get subHeadingStyle{
  return GoogleFonts.lato (
  textStyle:TextStyle(
   fontSize:24,
   fontWeight: FontWeight.bold,
  color: Get.isDarkMode? Colors.grey[400]:Colors.grey
  )
  );
}
TextStyle get headingStyle{
  return GoogleFonts.lato (
      textStyle:TextStyle(
          fontSize:30,
          fontWeight: FontWeight.bold,
          color: Get.isDarkMode? Colors.white:Colors.black
      )
  );
}
TextStyle get titleStyle{
  return GoogleFonts.lato (
      textStyle:TextStyle(
          fontSize:16,
          fontWeight: FontWeight.w600,
          color: Get.isDarkMode? Colors.white:Colors.black
      )
  );
}
TextStyle get subtitleStyle{
  return GoogleFonts.lato (
      textStyle:TextStyle(
          fontSize:14,
          fontWeight: FontWeight.w600,
          color: Get.isDarkMode?Colors.grey[100]:Colors.grey[600]
      )
  );
}