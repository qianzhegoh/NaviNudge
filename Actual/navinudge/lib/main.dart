import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
                  height:50,
                  width:300,
                  child: FilledButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const BluetoothSelect())
                      );
                    },
                    child: const Text("Yes, connect my NaviNudge", style:TextStyle(fontSize: 18)),
                  ),
                ),
                SizedBox(height:10),
                SizedBox(
                  height: 50,
                  width: 300,
                  child: FilledButton(
                    onPressed: () {},
                    child: const Text("No, I am a caretaker", style: TextStyle(fontSize: 18)),
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
      appBar: AppBar(title: const Text("Connect my NaviNudge")),
      body: 
      Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Found Devices:', style: TextStyle(fontSize: 32)),
            SizedBox(height:50),
            SizedBox(
              height: 60,
              width:300,
              child: ElevatedButton(
                onPressed: () {
                  final snackBar = SnackBar(
                    content: const Text('NaviNudge connected'),
                    action: SnackBarAction(
                      label: 'Cancel',
                      onPressed: (){
                        Navigator.pop(context);
                      },
                    )
                    );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context)=> ProfilePage())
                  );
                }, 
                child: Text("NaviNudge #1368", style:TextStyle(fontSize: 24)))),
            SizedBox(height:20),
            SizedBox(
              height: 60,
              width:300,
              child: ElevatedButton(
                onPressed: () {}, 
                child: Text("NaviNudge #9858", style:TextStyle(fontSize: 24)))),
            SizedBox(height: 20),
            SizedBox(
              height: 60,
              width:300,
              child: ElevatedButton(
                onPressed: () {}, 
                child: Text("NaviNudge #1309", style:TextStyle(fontSize: 24)))),
            SizedBox(height: 20),
            SizedBox(
              height: 60,
              width:300,
              child: ElevatedButton(
                onPressed: () {}, 
                child: Text("NaviNudge #7879", style:TextStyle(fontSize: 24))))
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: (){},
        icon:const Icon(Icons.refresh),
        label: const Text('Refresh')
        ),
    );
  }
}

// ignore: must_be_immutable
class ProfilePage extends StatelessWidget {

  var selectedIndex = 1; // This is to indicate that 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My Profile"),),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(Icons.home),
            icon: Icon(Icons.home_outlined), 
            label: 'Home'),
          NavigationDestination(
            selectedIcon: Icon(Icons.person),
            icon: Icon(Icons.person_outline),
            label: 'Profile'),
        ]
        )
    );
  }
}
