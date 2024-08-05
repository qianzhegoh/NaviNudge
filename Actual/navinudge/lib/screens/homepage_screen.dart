// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'bluetooth_setup_screen.dart';
import 'location_tracker_screen.dart';
import 'profile_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  late GoogleMapController mapController;

//sets the location of the saved locations 
  static const _school = LatLng(1.3412841720874797, 103.96375602825361);
  static const _market = LatLng(1.3352386703088892, 103.96330804919691);
  static const _home = LatLng(1.3423764200463901, 103.96427544320599);

  var markers;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  List<Widget> _pages() => <Widget>[
        GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _home,
            zoom: 17.0,
          ),
          //displays the markers for the saved locations 
          markers:{
            const Marker(
              markerId: MarkerId('School'), 
              icon: BitmapDescriptor.defaultMarker, 
              position: _school),  

            const Marker(
              markerId: MarkerId('Market'),
              icon: BitmapDescriptor.defaultMarker, 
              position: _market ),          

            const Marker(
              markerId: MarkerId('Home'),
              icon: BitmapDescriptor.defaultMarker, 
              position: _home,
              )
          }
        ),
      
        ProfilePage(),
      ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        _pages().elementAt(_selectedIndex),
        Positioned(
            bottom: 60,
            left: MediaQuery.of(context).size.width / 2 - 80,
            child: FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LocationTracker()));
              },
              icon: Icon(Icons.play_arrow),
              label: Text("Start Navigation")
            ))
      ]),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

class NavigationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text('Please choose your destination'),
        ),
      body: Center(
        child: Column(
          children: [SizedBox(
            height:50,
            width: 300,
            child: ElevatedButton(
              onPressed: (){
                Navigator.push(
                  context, MaterialPageRoute(builder: (context) => BluetoothSetup())
                );
              }, 
              child: const Text("Bluetooth example",
                        style: TextStyle(fontSize: 18)),))],
          ),
      )
    );
  }
}

