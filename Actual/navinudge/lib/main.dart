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
              Text(textScaler: TextScaler.linear(4),"Welcome"),
              SizedBox(height:50),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 50.0),
                child: TextField(
                  decoration: InputDecoration(border: OutlineInputBorder(),labelText: "Username", icon: Icon(Icons.person)),),
              ),
              SizedBox(height:10.0),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 50.0),
                child: TextField(decoration:InputDecoration(border: OutlineInputBorder(),labelText: "Password", icon:Icon(Icons.password)),),
              ),
              SizedBox(height: 50),
              ElevatedButton(onPressed:null, child: Text('Login')),
              SizedBox(height: 5),
              ElevatedButton(onPressed: null, child: Text('Sign Up'))
            ],
          ),
            ),
      )
    );
  }
}