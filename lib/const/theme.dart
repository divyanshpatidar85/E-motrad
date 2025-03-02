import 'package:flutter/material.dart';


const Color red = Color.fromARGB(255, 6, 231, 96);
const Color bitterSweet = Color.fromARGB(255, 6, 231, 96);
const Color lightPrimaryColor = Color.fromARGB(255, 6, 231, 96);
const Color melon = Color.fromARGB(255, 6, 231, 96);
const Color white = Colors.white;
const Color darkPrimaryColor = Colors.black;
const double toolbarHeight = 80;

class Themes {
  static final light = ThemeData(
    colorScheme: const ColorScheme.light(primary: red),
    buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
  );
  static final dark = ThemeData(
      primaryColor: darkPrimaryColor,
      // white10:colors.wait,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark());
  static final white = ThemeData(
      primaryColor: Colors.white,
      // white10:colors.wait,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark());
}

TextStyle get subHeadingStyle {
  return  const TextStyle(
        color: darkPrimaryColor,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w500);
}

TextStyle headingStyle(BuildContext context) {
  return TextStyle(
   
    fontSize: 18,
    fontFamily: 'poppin',
    fontWeight: FontWeight.bold,
   
  );
}

TextStyle get buttonTextStyle {
  return const TextStyle(
      fontWeight: FontWeight.bold, fontSize: 18, color: white);
}

TextStyle get labelStyle {
  return  TextStyle(
        fontSize:25,
        color: darkPrimaryColor,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w600);
  
}

TextStyle get labelValueStyle {
  return  const TextStyle(
        color: darkPrimaryColor,
        fontFamily: 'Poppins',
        fontWeight: FontWeight.w500);
  
}

double getWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

double getHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}