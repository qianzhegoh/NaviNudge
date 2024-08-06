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
              backgroundImage: AssetImage(
                  'assets/images/defaultProfile.jpg'), // Default avatar image
            ),
            SizedBox(height: 20),
            // Profile name
            Text(
              'Josephine Tan',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height:10),
            Text('tanjosephine8@gmail.com'),
            SizedBox(height: 50),
            Text('Settings',
              textAlign: TextAlign.left,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            // Caretaker mode button
            SizedBox(
              height: 50,
              width: 300,
              child: FilledButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CaretakerOverview()));
                },
                child: Text('Caretaker Mode'),
              ),
            ),
            SizedBox(height: 10),
            Text('Help',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            // Customer Support button
            SizedBox(
              height: 50,
              width: 300,
              child: FilledButton(
                onPressed: () {showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                            title: Text('Customer Support'),
                            content: Text(
                                'Contact us at grp7.2024.30.007@gmail.com'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: Text('OK'),
                              ),
                            ],
                          ));
                },
                child: Text('Customer Support'),
              ),
            ),
            SizedBox(height: 10),
            // App Information button
            SizedBox(
              height: 50,
              width: 300,
              child: FilledButton(
                onPressed: () {
                  showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (BuildContext context) => AlertDialog(
                            title: Text('NaviNudge'),
                            content: Text(
                                'Version 0.0.1. \n Built by Pan Ziyue, Goh Qian Zhe and Woo Syn Hwee Abigail.'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: Text('OK'),
                              ),
                            ],
                          ));
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
