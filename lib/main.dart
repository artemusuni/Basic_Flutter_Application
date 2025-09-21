import 'package:flutter/material.dart'; //I am importing the material library

void main() => runApp(const MyApp());  //The entry point to my Dart program

class MyApp extends StatelessWidget {

  const MyApp({super.key});    //Constructor passes 'super.key' as optional key
                              //to the base class for identity.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 1',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
        brightness: Brightness.dark,
      ),
      home: const Scaffold(
        body: Center(
          child: Text("Hello, Flutter"),
        ),
      ),
    );

  }

}
