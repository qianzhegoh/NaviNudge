import 'package:flutter/material.dart';

void main() {
  runApp(NaviNudgeApp());
}

class NaviNudgeApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NaviNudge',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: NaviNudgeHomePage(),
    );
  }
}

class NaviNudgeHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.arrow_back),
        title: Text('NaviNudge'),
        actions: [
          Icon(Icons.settings),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(height: 20),
            Center(
              child: Icon(
                Icons.explore,
                size: 100,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Choose your intended Destination',
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: null,
              icon: Icon(Icons.location_pin),
              label: Text('Select from your saved locations'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.grey[300],
                backgroundColor: Colors.grey,
                shadowColor: Colors.transparent,
              ),
            ),
            SizedBox(height: 20),
            DestinationButton(
              icon: Icons.home,
              label: 'Home',
            ),
            DestinationButton(
              icon: Icons.shopping_cart,
              label: 'Market',
            ),
            DestinationButton(
              icon: Icons.school,
              label: 'School',
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Market',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.arrow_back),
            label: 'Back',
          ),
        ],
      ),
    );
  }
}

class DestinationButton extends StatelessWidget {
  final IconData icon;
  final String label;

  DestinationButton({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      child: ElevatedButton.icon(
        onPressed: () {},
        icon: Icon(icon, color: Colors.blue),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.black,
          shadowColor: Colors.transparent,
          side: BorderSide(color: Colors.blue),
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          textStyle: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}