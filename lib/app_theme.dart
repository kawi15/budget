import 'package:budzet/text_style_base.dart';
import 'package:flutter/material.dart';

class AppTheme {

  static ThemeData get lightTheme =>
      ThemeData(
          useMaterial3: true,
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
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.greenAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              )
            )
          ),
          brightness: Brightness.light

      );

  static ThemeData get darkTheme =>
      ThemeData(
        useMaterial3: true,
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
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.greenAccent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                )
            )
        ),
        brightness: Brightness.dark,
      );
}