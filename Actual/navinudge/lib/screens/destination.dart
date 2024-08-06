import 'package:flutter/material.dart';
import 'directions.dart';
import 'location_tracker_screen.dart';
import '../utils/navigation_controller.dart';
import 'package:get/get.dart';

class DestinationSelect extends StatefulWidget {
  @override
  State<DestinationSelect> createState() => _DestinationSelectState();
}

class _DestinationSelectState extends State<DestinationSelect> {
  final navController = Get.put(NavigationController(), permanent: true);
  var destination = '';  // Change this destination to what the location picker says!
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Destination Selection'),
        actions: <Widget>[
          IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LocationTracker()));
              },
              icon: Icon(
                Icons.bug_report,
              ))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [

              Text(
                'Choose your intended destination:',
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              TextField(
                decoration: InputDecoration(
                  labelText: 'Input your destination',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 30),
              Text(
                'Favorites:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              SizedBox(
                  height: 50,
                  width: 300,
                  child: FilledButton.icon(
                      onPressed: () {
                        destination =
                            "Block 59, 59 Changi South Ave 1, Singapore 485999";
                        navController.beginRouting(destination);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Directions()));
                      },
                      icon: const Icon(Icons.home_filled),
                      label: const Text('Home'))),
              SizedBox(height: 10),
              SizedBox(
                  height: 50,
                  width: 300,
                  child: FilledButton.icon(
                      onPressed: () {
                        destination = "McDonald's Eastpoint Mall";
                        navController.beginRouting(destination);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Directions()));
                      },
                      icon: const Icon(Icons.fastfood),
                      label: const Text('McDonald\'s'))),
              SizedBox(height: 10),
              SizedBox(
                  height: 50,
                  width: 300,
                  child: FilledButton.icon(
                      onPressed: () {
                        destination = 'Singapore Polytechnic';
                        navController.beginRouting(destination);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Directions()));
                      },
                      icon: const Icon(Icons.school),
                      label: const Text('School')))
            ],
          ),
        ),
      ),
    );
  }
}
