import 'package:budzet/text_style_base.dart';
import 'package:flutter/material.dart';

class AppTheme {

  static ThemeData get lightTheme =>
      ThemeData(
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
              color: Colors.white,
              titleTextStyle: TextStyleBase.appBarLight
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
          titleTextStyle: TextStyleBase.appBarDark
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