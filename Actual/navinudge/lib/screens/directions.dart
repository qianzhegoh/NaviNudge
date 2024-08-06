import 'package:flutter/material.dart';
import 'homepage_screen.dart';
import '../utils/navigation_controller.dart';
import 'package:get/get.dart';

//QZ: I am not too sure how to integrate the steps (which part of the journey, wether if its bus mode or walking mode).
//Hence, I have created 3 different screens instead.

// Note: by the time this screen fires, the destination picker should have picked by the previous view and sent to this screen
// for now, this is hardcoded

class Directions extends StatelessWidget {
  final NavigationController navController =
      Get.put(NavigationController(), permanent: true);

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     appBar: AppBar(
  //       title: Text('Directions'),
  //     ),
  //     body: Obx(() {
  //       return Column(
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           // Profile picture
  //           CircleAvatar(
  //             radius: 80,
  //             backgroundImage: AssetImage(
  //             'assets/images/walking.png'), // Default avatar image
  //           ),
  //           SizedBox(height: 20),
  //           // Profile name
  //           Text(
  //             'Walking. Please use guidance from NaviNudge',
  //             style: TextStyle(
  //               fontSize: 24,
  //               fontWeight: FontWeight.bold,
  //             ),
  //             textAlign: TextAlign.center,
  //           ),
  //           SizedBox(height: 50),
  //           TextButton(
  //               onPressed: () {
  //                 Navigator.push(context,
  //                     MaterialPageRoute(builder: (context) => DirectionsBus()));
  //               },
  //               child: Text('$navController.onRoute'))
  //         ],
  //       );
  //     }),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Directions'),
        centerTitle: true,
      ),
      body: Obx(() {
        return Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 80,
              backgroundImage: AssetImage(
                  'assets/images/walking.png'), // Default avatar image
            ),
            SizedBox(height: 20),
            Text(
              'Walking. Please use guidance from NaviNudge',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 50),
            SizedBox(height: 50),
            TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => DirectionsBus()));
                },
                child: Text('${navController.onRoute}')),
            // Text(
            //   "Current coordinates: ${navController.currentCoordinates}\nGPS accuracy: ${navController.gpsAccuracy}",
            //   style: TextStyle(
            //     fontSize: 24,
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),
          ],
        ));
      }),
    );
  }
}

/*

*/

class DirectionsBus extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Directions'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Profile picture
            CircleAvatar(
              radius: 80,
              backgroundImage:
                  AssetImage('assets/images/bus.png'), // Default avatar image
            ),
            SizedBox(height: 20),
            // Profile name
            Text(
              'Please take Bus 5 towards Bt Merah Int. The bus comes every 15 minutes.',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 50),
            TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => DirectionsEnd()));
                },
                child: Text('p'))
          ],
        ),
      ),
    );
  }
}

class DirectionsEnd extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Directions'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Profile picture
            CircleAvatar(
              radius: 80,
              backgroundImage:
                  AssetImage('assets/images/end.png'), // Default avatar image
            ),
            SizedBox(height: 20),
            // Profile name
            Text(
              'You have reached your destination',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 50),
            TextButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HomePage()));
                },
                child: Text('p'))
          ],
        ),
      ),
    );
  }
}
