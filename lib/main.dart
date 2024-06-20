import 'package:flutter/material.dart';
import 'start.dart';

void main() => runApp(
      MaterialApp(
        home: const FirstPage(),
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
            backgroundColor: Color.fromARGB(255, 18, 19, 20),
            titleTextStyle: TextStyle(color: Colors.white, fontSize: 30),
            shadowColor: Color.fromARGB(255, 66, 66, 66),
            foregroundColor: Colors.white,
            elevation: 5,
          ),
          fontFamily: 'Questrial',
        ),
      ),
    );
