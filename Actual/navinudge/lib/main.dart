// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'utils/ble_controller.dart';
import 'package:permission_handler/permission_handler.dart';



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
// Developer's note: I am currently updating the code for this to work with our device.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Connect my NaviNudge")),
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

  final LatLng _center = const LatLng(1.3412841720874797, 103.96375602825361);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  List<Widget> _pages() => <Widget>[
        GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 17.0,
          ),
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
                    MaterialPageRoute(builder: (context) => NavigationPage()));
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

class BluetoothSetup extends StatefulWidget {
  const BluetoothSetup({super.key});

  @override
  State<BluetoothSetup> createState() => _BluetoothSetupState();
}

class _BluetoothSetupState extends State<BluetoothSetup> {
  final BleController bleController = Get.put(BleController());

  Future<void> _requestPermissions() async {
    if (await Permission.bluetoothScan.request().isGranted &&
        await Permission.locationWhenInUse.request().isGranted) {
      // Permissions are granted
    } else {
      Get.snackbar("Permission Denied", "Bluetooth and Location permissions are required to scan for devices.",
          snackPosition: SnackPosition.BOTTOM);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("BLE SCANNER")),
      body: GetBuilder<BleController>(
        init: bleController,
        builder: (BleController controller) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Obx(() {
                  if (controller.scanResults.isEmpty) {
                    return Center(child: Text("No Device Found"));
                  } else {
                    return Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: controller.scanResults.length,
                        itemBuilder: (context, index) {
                          final data = controller.scanResults[index];
                          return Card(
                            elevation: 2,
                            child: ListTile(
                              title: Text(data.device.platformName),
                              subtitle: Text(data.device.remoteId.toString()),
                              trailing: Text(data.rssi.toString()),
                              onTap: () => controller.connectToDevice(data.device),
                            ),
                          );
                        },
                      ),
                    );
                  }
                }),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () async {
                    await _requestPermissions();
                    controller.scanDevices();
                  },
                  child: Text("SCAN"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}