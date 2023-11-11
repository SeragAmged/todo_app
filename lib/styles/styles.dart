import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

ThemeData appLightTheme = ThemeData(
  primaryColor: Colors.grey,
  primarySwatch: Colors.grey,
  scaffoldBackgroundColor: Colors.grey.shade300,
  appBarTheme: AppBarTheme(
    systemOverlayStyle: const SystemUiOverlayStyle(
      statusBarColor: Colors.black45,
      statusBarIconBrightness: Brightness.light,
    ),
    elevation: 0.0,
    color: Colors.grey.shade300,
    titleTextStyle: const TextStyle(
      color: Colors.black,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    iconTheme: const IconThemeData(
      color: Colors.black,
    ),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Colors.black,
  ),
  bottomSheetTheme: const BottomSheetThemeData(),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    type: BottomNavigationBarType.fixed,
    backgroundColor: Colors.black,
    selectedItemColor: Colors.white,
    unselectedItemColor: Colors.grey,
    showUnselectedLabels: false,
  ),
);

ThemeData appDarkTheme = ThemeData(
  primaryColor: Colors.white,
  // primarySwatch: MaterialSta,
  scaffoldBackgroundColor: Colors.black,
  appBarTheme: const AppBarTheme(
    systemOverlayStyle: SystemUiOverlayStyle(
      statusBarColor: Colors.black,
      statusBarIconBrightness: Brightness.light,
    ),
    elevation: 0.0,
    color: Colors.black,
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    iconTheme: IconThemeData(
      color: Colors.white,
    ),
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: Colors.white,
    
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
    type: BottomNavigationBarType.fixed,
    backgroundColor: Colors.black,
    selectedItemColor: Colors.white,
    unselectedItemColor: Colors.grey,
    showUnselectedLabels: true,
  ),
);
