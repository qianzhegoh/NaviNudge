import 'package:flutter/material.dart';

import 'real_bluetooth_setup_screen.dart';
import 'profile_screen.dart';

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
                              builder: (context) => const BluetoothSetup()));
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
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfilePage()));
                    },
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
