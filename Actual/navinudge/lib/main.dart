// ignore_for_file: library_private_types_in_public_api

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:geolocator_platform_interface/src/enums/location_accuracy.dart' as platform_interface; 
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import 'screens/loginpage_screen.dart';

void main() {
  FlutterBluePlus.setLogLevel(LogLevel.verbose, color:false);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        textTheme: GoogleFonts.openSansTextTheme(),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue),
      ),
      home: const LoginPage(),
    );
  }
}
