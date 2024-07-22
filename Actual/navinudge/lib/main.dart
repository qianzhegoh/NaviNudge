import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MyApp());
}

class ImageBanner extends StatelessWidget {
  final String _assetPath;

  ImageBanner(this._assetPath);

  @override
  Widget build(BuildContext context) {
    return Container(
        constraints: BoxConstraints.expand(height: 200.0),
        decoration: BoxDecoration(color: Colors.grey),
        child: Image.asset(
          _assetPath,
          fit: BoxFit.cover,
        ));
  }
}

class MyApp extends StatelessWidget{
  const MyApp({Key? key}) : super(key: key);
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
              DecoratedBox(decoration: BoxDecoration(image: DecorationImage(image: AssetImage('assets/images/navinudge_logo.png')))),
              Text(textScaler: TextScaler.linear(2.5),"Welcome"),
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