import 'package:flutter/material.dart';
import 'caretaker_screen.dart';

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
              'Josephine Tan',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 100),
            Text('Settings', style:TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height:10),
            // Caretaker mode button
            SizedBox(
              height: 50,
              width: 300,
              child: FilledButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>CaretakerOverview()));
                },
                child: Text('Caretaker Mode'),
              ),
            ),
            SizedBox(height: 10),
            Text('Help', style:TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height:10),
            // Customer Support button
            SizedBox(
              height:50,
              width:300,
              child: FilledButton(
                onPressed: () {
                  // Add your onPressed code here!
                },
                child: Text('Customer Support'),
              ),
            ),
            SizedBox(height: 10),
            // App Information button
            SizedBox(
              height:50,
              width:300,
              child: FilledButton(
                onPressed: () {
                  // Add your onPressed code here!
                },
                child: Text('App Information'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
