import 'package:flutter/material.dart';

class AppTheme {

  static ThemeData get lightTheme =>
      ThemeData(
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
              color: Colors.white,
              titleTextStyle: TextStyle(
                color: Colors.black,
                fontSize: 16
              )
          ),
          drawerTheme: const DrawerThemeData(
            backgroundColor: Colors.white,
          ),
          bottomAppBarTheme: const BottomAppBarTheme(
              color: Colors.white
          ),
          brightness: Brightness.light

      );

  static ThemeData get darkTheme =>
      ThemeData(
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(
          color: Colors.black,
          iconTheme: IconThemeData(
              color: Colors.white
          ),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 16
          )
        ),
        drawerTheme: const DrawerThemeData(
          backgroundColor: Colors.black,
        ),
        bottomAppBarTheme: const BottomAppBarTheme(
          color: Colors.black
        ),
        brightness: Brightness.dark,
      );
}