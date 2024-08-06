import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'location_tracker_screen.dart';

class CaretakerOverview extends StatefulWidget {
  const CaretakerOverview({Key? key}) : super(key: key);

  @override
  _CaretakerOverviewState createState() => _CaretakerOverviewState();
}

class _CaretakerOverviewState extends State<CaretakerOverview> {
  int _selectedIndex = 0;
  late GoogleMapController mapController;

//sets the location of the saved locations
  static const _son = LatLng(1.3412841720874797, 103.96375602825361);
  static const _mother = LatLng(1.3352386703088892, 103.96330804919691);
  static const _father = LatLng(1.3423764200463901, 103.96427544320599);

  var markers;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  List<Widget> _pages() => <Widget>[
        GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _son,
              zoom: 14.0,
            ),
            //displays the markers for the saved locations
            markers: {
              Marker(
                  markerId: MarkerId('School'),
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueCyan),
                  position: _son),
              Marker(
                  markerId: MarkerId('Market'),
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueMagenta),
                  position: _father),
              Marker(
                markerId: MarkerId('Home'),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueRose),
                position: _mother,
              )
            }),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('People'),
      ),
      body: Column(children: [
        SizedBox(
            height: 400, width: 400, child: _pages().elementAt(_selectedIndex)),
        SizedBox(height: 50),
        ListView.builder(
            shrinkWrap: true,
            itemCount: 3,
            itemBuilder: (context, index) {
              return Card(
                  elevation: 2,
                  child: ListTile(
                    title: Text('test'),
                    subtitle: Text('test'),
                    trailing: Text('etst'),
                    onTap: () {},
                  ));
            })
      ]),
    );
  }
}
