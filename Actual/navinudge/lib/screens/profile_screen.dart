import 'package:flutter/material.dart';
import 'package:navinudge/screens/destination.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Profile picture
            CircleAvatar(
              radius: 80,
              backgroundImage: AssetImage('assets/images/defaultProfile.jpg'), // Default avatar image
            ),
            SizedBox(height: 20),
            // Profile name
            Text(
              'Profile Name',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            // Caretaker mode button
            FilledButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>NaviNudgeHomePage()));
              },
              child: Text('Caretaker Mode'),
            ),
            SizedBox(height: 10),
            // Customer Support button
            FilledButton(
              onPressed: () {
                // Add your onPressed code here!
              },
              child: Text('Customer Support'),
            ),
            SizedBox(height: 10),
            // App Information button
            FilledButton(
              onPressed: () {
                // Add your onPressed code here!
              },
              child: Text('App Information'),
            ),
          ],
        ),
      ),
    );
  }
}
