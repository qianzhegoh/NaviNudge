import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'bluetooth_setup_screen.dart';
import 'profile_screen.dart';
import 'destination.dart';
import '../utils/navigation_controller.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  late GoogleMapController mapController;
  final navController = Get.put(NavigationController(), permanent: true);

//sets the location of the saved locations 
  static const _school = LatLng(1.341588937316322, 103.96284222213933);
  static const _market = LatLng(1.3352386703088892, 103.96330804919691);
  static const _home = LatLng(1.3423764200463901, 103.96427544320599);

  var markers;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    navController.startLocationStream(); // opportunistically start the location controller once the homepage is up
  }

  List<Widget> _pages() => <Widget>[
        GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _school,
            zoom: 17.0,
          ),
          //displays the markers for the saved locations 
          markers:{
            const Marker(
              markerId: MarkerId('School'), 
              icon: BitmapDescriptor.defaultMarker, 
              position: _school),  

            // const Marker(
            //   markerId: MarkerId('Market'),
            //   icon: BitmapDescriptor.defaultMarker, 
            //   position: _market ),          

            // const Marker(
            //   markerId: MarkerId('Home'),
            //   icon: BitmapDescriptor.defaultMarker, 
            //   position: _home,
            //   )
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
      appBar: AppBar(
         actions: <Widget>[
          IconButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>ProfilePage()));
          }, icon: Icon(Icons.person,))],
        title: const Text('Home'),),
      body: Stack(children: [
        _pages().elementAt(_selectedIndex),
        Positioned(
            bottom: 60,
            left: MediaQuery.of(context).size.width / 2 - 80,
            child: FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => DestinationSelect()));
              },
              icon: Icon(Icons.play_arrow),
              label: Text("Start Navigation")
            ))
      ]),
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
                  context, MaterialPageRoute(builder: (context) => BluetoothDebugger())
                );
              }, 
              child: const Text("Bluetooth example",
                        style: TextStyle(fontSize: 18)),))],
          ),
      )
    );
  }
}

