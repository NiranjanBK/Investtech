import 'package:flutter/material.dart';
import 'package:investtech_app/const/colors.dart';

class AppThemes {
  static final appThemeData = {
    AppTheme.lightTheme: ThemeData(
      scaffoldBackgroundColor: Colors.white,
      //primarySwatch: Colors.orange,
      backgroundColor: const Color(0XFFf5f3f3),
      primaryColor: const Color(ColorHex.windowBackground),
      primaryColorDark: const Color(ColorHex.black), //const Color(0XFFf5f3f3),

      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        titleTextStyle: TextStyle(fontSize: 20, color: Color(ColorHex.black)),
        toolbarTextStyle: TextStyle(color: Color(ColorHex.black), fontSize: 14),
        iconTheme: IconThemeData(
          color: Colors.black54,
        ),
      ),

      iconTheme: const IconThemeData(color: Color(0xFFC0C0C0)),

      // Define the default font family.
      //fontFamily: 'Georgia',

      // Define the default `TextTheme`. Use this to specify the default
      // text styling for headlines, titles, bodies of text, and more.
      textTheme: const TextTheme(
          bodyText1: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 15,
              color: Color(ColorHex.DARK_GREY)),
          bodyText2: TextStyle(fontSize: 12, color: Color(ColorHex.DARK_GREY)),
          subtitle1: TextStyle(fontSize: 13, color: Color(ColorHex.warmGrey)),
          headline4: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Color(ColorHex.black)),
          headline3: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: Color(ColorHex.black)),
          headline1: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Color(ColorHex.black)),
          headline2: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Color(ColorHex.black)),
          caption: TextStyle(
            fontSize: 14,
            color: Color(ColorHex.DARK_GREY),
          )),

      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedIconTheme: IconThemeData(color: Color(0xFFFF6600)),
        selectedItemColor: Color(0xFFFF6600),
        unselectedIconTheme: IconThemeData(color: Color(0xFF6e6e6e)),
        //unselectedLabelStyle: TextStyle(color: Colors.blue),
      ),
    ),
    AppTheme.darkTheme: ThemeData(
      scaffoldBackgroundColor: const Color(ColorHex.black_chart_bg),
      primaryColor: const Color(ColorHex.black_chart_bg),
      primaryColorDark: const Color(ColorHex.white),
      //primarySwatch: Colors.teal,
      backgroundColor: Colors.black,
      textTheme: const TextTheme(
          bodyText1: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: Color(0xffb3afaf)),
          bodyText2: TextStyle(fontSize: 12, color: Color(0xffb3afaf)),
          subtitle1: TextStyle(fontSize: 13, color: Color(0xffb3afaf)),
          headline4: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Color(ColorHex.white)),
          headline3: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: Color(ColorHex.white)),
          headline2: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Color(ColorHex.white)),
          headline1: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: Color(ColorHex.white)),
          caption: TextStyle(
            fontSize: 14,
            color: Color(0xFFE8E8E8),
          )),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF3d3d3d),
        titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
        toolbarTextStyle: TextStyle(color: Colors.white, fontSize: 14),
        iconTheme: IconThemeData(
          color: Colors.white54,
        ),
      ),
      iconTheme: const IconThemeData(color: Color(0xFF3d3d3d)),

      dialogTheme: const DialogTheme(
        backgroundColor: Color(0xFF282828),
        titleTextStyle: TextStyle(
          color: Color(0xFF9b9b9b),
        ),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF3d3d3d),
        selectedIconTheme: IconThemeData(color: Color(0xFFFF6600)),
        selectedItemColor: Color(0xFFFF6600),
        unselectedItemColor: Color(0xFFE8E8E8),
        // unselectedLabelStyle: TextStyle(color: Colors.blue),
      ),
    )
  };
}

enum AppTheme {
  lightTheme,
  darkTheme,
}
