import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(backgroundColor:Colors.green,
        title: const Text('Hello World')),
        body: const Center(
          child: Text(
            'This is a text!'
            ),
            ),
      )
    );
  }
}