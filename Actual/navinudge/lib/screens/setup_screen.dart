import 'package:flutter/material.dart';

import 'bluetooth_setup_screen.dart';
import 'homepage_screen.dart';

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
                SizedBox(height: 10),
                SizedBox(
                  height:50,
                  width:300,
                  child: FilledButton(
                    onPressed: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const BluetoothSetup()));
                    },
                    child: const Text('BT DEBUG MODE!', style: TextStyle(fontSize: 20))
                  )
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
