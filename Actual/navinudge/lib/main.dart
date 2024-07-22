import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        textTheme: GoogleFonts.openSansTextTheme(),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green)
        ),
      home: Scaffold(
        body: const Center(
          child: 
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton(onPressed:null, child: Text('Press Me'))
            ],
          ),
            ),
      )
    );
  }
}