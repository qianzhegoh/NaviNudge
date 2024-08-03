// ignore_for_file: library_private_types_in_public_api

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:geolocator_platform_interface/src/enums/location_accuracy.dart' as platform_interface; 
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';



void main() {
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

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.white, Colors.blue],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                width: 300,
                height: 300,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/navinudge_logo.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const Text(
                "Welcome",
                style: TextStyle(fontSize: 36), // Adjust fontSize as needed
              ),
              const SizedBox(height: 20),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 50.0),
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Username",
                    icon: Icon(Icons.person),
                  ),
                ),
              ),
              const SizedBox(height: 10.0),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 50.0),
                child: TextField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Password",
                    icon: Icon(Icons.lock),
                  ),
                  obscureText: true, // This hides the text input
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FilledButton(
                    onPressed: () {
                      // Add sign-up action here
                    },
                    child: const Text('Sign Up'),
                  ),
                  const SizedBox(width: 10),
                  FilledButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const SetUp()),
                      );
                    },
                    child: const Text('Log In'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SetUp extends StatelessWidget {
  const SetUp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Set up your device")),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                "Do you have a NaviNudge Device?",
                style: TextStyle(fontSize: 34), // Adjust fontSize as needed
              ),
            ),
            const SizedBox(height: 50),
            Column(
              children: [
                SizedBox(
                  height: 50,
                  width: 300,
                  child: FilledButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const BluetoothSelect()));
                    },
                    child: const Text("Yes, connect my NaviNudge",
                        style: TextStyle(fontSize: 18)),
                  ),
                ),
                SizedBox(height: 10),
                SizedBox(
                  height: 50,
                  width: 300,
                  child: FilledButton(
                    onPressed: () {},
                    child: const Text("No, I am a caretaker",
                        style: TextStyle(fontSize: 18)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Back to Log In Page'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class BluetoothSelect extends StatelessWidget {
  const BluetoothSelect({Key? key}) : super(key: key);
// Developer's Note: Bluetooth functionality has not been developed for this app. Refer to flutter_blue documentation.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("connect my NaviNudge")),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Found Devices:', style: TextStyle(fontSize: 32)),
            SizedBox(height: 50),
            SizedBox(
                height: 60,
                width: 300,
                child: ElevatedButton(
                    onPressed: () {
                      final snackBar = SnackBar(
                          content: const Text('NaviNudge connected'),
                          action: SnackBarAction(
                            label: 'Cancel',
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ));
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => HomePage()));
                    },
                    child: Text("NaviNudge #1368",
                        style: TextStyle(fontSize: 24)))),
            SizedBox(height: 20),
            SizedBox(
                height: 60,
                width: 300,
                child: ElevatedButton(
                    onPressed: () {},
                    child: Text("NaviNudge #9858",
                        style: TextStyle(fontSize: 24)))),
            SizedBox(height: 20),
            SizedBox(
                height: 60,
                width: 300,
                child: ElevatedButton(
                    onPressed: () {},
                    child: Text("NaviNudge #1309",
                        style: TextStyle(fontSize: 24)))),
            SizedBox(height: 20),
            SizedBox(
                height: 60,
                width: 300,
                child: ElevatedButton(
                    onPressed: () {},
                    child: Text("NaviNudge #7879",
                        style: TextStyle(fontSize: 24))))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {},
          icon: const Icon(Icons.refresh),
          label: const Text('Refresh')),
    );
  }
}


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
              position: _home
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
          children: const [
            Text('Profile Content'),
          ],
        ),
      ),
    );
  }
}

class LocationTracker extends StatefulWidget {
  @override
  _LocationTrackerState createState() => _LocationTrackerState();
}

class _LocationTrackerState extends State<LocationTracker> {
  geolocator.Position? _currentPosition;
  String _currentAddress = 'Fetching location...';

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    geolocator.LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await geolocator.Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled, open settings
      await geolocator.Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }

    permission = await geolocator.Geolocator.checkPermission();
    if (permission == geolocator.LocationPermission.denied) {
      permission = await geolocator.Geolocator.requestPermission();
      if (permission == geolocator.LocationPermission.denied) {
        // Permissions are denied, next time you could try requesting permissions again
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == geolocator.LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can continue accessing the position of the device.
    geolocator.Geolocator.getPositionStream(
      locationSettings: geolocator.LocationSettings(
        accuracy: platform_interface.LocationAccuracy.high,
        distanceFilter: 10,
      ),
    ).listen((geolocator.Position position) {
      setState(() {
        _currentPosition = position;
        _currentAddress =
            'Lat: ${position.latitude}, Long: ${position.longitude}';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Location Tracker'),
      ),
      body: Center(
        child: Text(
          _currentAddress,
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
//somewhat working code w 1 red issue
// class LocationTracker extends StatefulWidget {
//   @override
//   _LocationTrackerState createState() => _LocationTrackerState();
// }

// class _LocationTrackerState extends State<LocationTracker> {
//   Position? _currentPosition;
//   String _currentAddress = 'Fetching location...';

//   @override
//   void initState() {
//     super.initState();
//     _getCurrentLocation();
//   }

//   Future<void> _getCurrentLocation() async {
//     bool serviceEnabled;
//     LocationPermission permission;

//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       await Geolocator.openLocationSettings();
//       return Future.error('Location services are disabled.');
//     }

//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         return Future.error('Location permissions are denied.');
//       }
//     }

//     if (permission == LocationPermission.deniedForever) {
//       return Future.error(
//           'Location permissions are permanently denied, we cannot request permissions.');
//     }

//   Geolocator.getPositionStream(
//     locationSettings: LocationSettings(
//     accuracy: LocationAccuracy.high,
//     distanceFilter: 10,
//   ),
// ).listen((Position position) {
//   setState(() {
//     _currentPosition = position;
//     _currentAddress =
//         'Lat: ${position.latitude}, Long: ${position.longitude}';
//   });
// });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Location Tracker'),
//       ),
//       body: Center(
//         child: Text(
//           _currentAddress,
//           style: TextStyle(fontSize: 24),
//         ),
//       ),
//     );
//   }
// }
 //newest working code ends here

// class GoogleMapPage extends StatefulWidget {
//   const GoogleMapPage({super.key});

//   @override
//   State<GoogleMapPage> createState() => NavigationPage();
// }

// class NavigationPage extends State<GoogleMapPage> {

//   final Location location = Location();
//   LatLng? currentPosition;

//   void initState() {
//     WidgetsBinding.instance
//         .addPostFrameCallback((_) async => await fetchLocationUpdates());
  // }

  // Future<void> initializeMap() async {
  //   await fetchLocationUpdates();
  //   // final coordinates = await fetchPolylinePoints();
  //   // generatePolyLineFromPoints(coordinates);
  // }

  // Future <void> fetchLocationUpdates() async {
  //   bool serviceEnabled;
  //   PermissionStatus permissionGranted; 
  //   serviceEnabled = await location.serviceEnabled();
  //   serviceEnabled = await location.serviceEnabled();
  //   if (!serviceEnabled) {
  //     serviceEnabled = await location.requestService();
  //     if (!serviceEnabled) {
  //       return;
  //     }
  //   }

  //   permissionGranted = await location.hasPermission();
  //   if (permissionGranted == PermissionStatus.denied) {
  //     permissionGranted = await location.requestPermission();
  //     if (permissionGranted != PermissionStatus.granted) {
  //       return;
  //     }
  //   }


    
  //   location.onLocationChanged.listen((currentLocation) {
  //     if (currentLocation.latitude != null &&
  //         currentLocation.longitude != null) {
  //       setState(() {
  //         currentPosition = LatLng(
  //           currentLocation.latitude!,
  //           currentLocation.longitude!,
  //         );
  //       });
  //     }
  //   });

  // }



  // bool _serviceEnabled = false;
  // PermissionStatus _permissionGranted;
  // LocationData _locationData;

  // _serviceEnabled = await location.serviceEnabled();
  // if (!_serviceEnabled) {
  //   _serviceEnabled = await location.requestService();
  //   if (!_serviceEnabled) {
  //     return;
  //   }
  // }

  // _permissionGranted = await location.hasPermission();
  // if (_permissionGranted == PermissionStatus.denied) {
  //   _permissionGranted = await location.requestPermission();
  //   if (_permissionGranted != PermissionStatus.granted) {
  //     return;
  //   }
  // }

  // _locationData = await location.getLocation();

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: const Text('Select your destination')),
  //     body: Center(
  //       child:Column(
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           Text('')
  //         ], 
  //       )
  //     )
  //   );
  // }

  // @override
  // Widget build(BuildContext context) => Scaffold(
  //       body: currentPosition == null
  //           ? const Center(child: CircularProgressIndicator())
  //           : GoogleMap(
  //               initialCameraPosition: const CameraPosition(
  //                 target: _HomePageState._home,
  //                 zoom: 13,
  //               ),
  //               markers: {
  //                 Marker(
  //                   markerId: const MarkerId('currentLocation'),
  //                   icon: BitmapDescriptor.defaultMarker,
  //                   position: currentPosition!,
  //                 ),
  //                 const Marker(
  //                   markerId: MarkerId('sourceLocation'),
  //                   icon: BitmapDescriptor.defaultMarker,
  //                   position: _HomePageState._home,
  //                 ),
  //                 const Marker(
  //                   markerId: MarkerId('destinationLocation'),
  //                   icon: BitmapDescriptor.defaultMarker,
  //                   position: _HomePageState._market,
  //                 )
  //               },
  //             ),
  //     );

// }


