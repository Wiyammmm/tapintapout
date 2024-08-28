import 'package:flutter/material.dart';

ThemeData appTheme = ThemeData(
  appBarTheme: const AppBarTheme(
      backgroundColor: Colors.lightBlue, foregroundColor: Colors.white),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(
        color: Colors.black, // You can change the border color
      ),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(
        color: Colors.black, // Color when the input field is enabled
        width: 1.0, // Border width
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(
        color: Colors.blueAccent, // Color when the input field is focused
        width: 1.0,
      ),
    ),
  ),
  colorScheme:
      ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 58, 137, 183)),
  useMaterial3: true,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      backgroundColor: MaterialStateProperty.all<Color>(
          Colors.blueAccent), // Set the background color
      foregroundColor:
          MaterialStateProperty.all<Color>(Colors.white), // Set the text color

      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // Set the border radius
        ),
      ),
    ),
  ),
);
