import 'package:flutter/material.dart';

class Directions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Directions'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Profile picture
            CircleAvatar(
              radius: 80,
              backgroundImage: AssetImage('assets/images/walking.png'), // Default avatar image
            ),
            SizedBox(height: 20),
            // Profile name
            Text(
              'Walking. Please use guidance from NaviNudge',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold,),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 100),
            
          ],
        ),
      ),
    );
  }
}


