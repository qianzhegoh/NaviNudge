import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SavedLocations extends StatefulWidget {
  const SavedLocations({Key? key}) : super(key: key);

  @override
  _CaretakerOverviewState createState() => _CaretakerOverviewState();
}

class _CaretakerOverviewState extends State<SavedLocations> {
  int _selectedIndex = 0;
  late GoogleMapController mapController;

  //sets the location of the saved locations
  static const _home = LatLng(1.3652153503355429, 103.95916265424493);
  static const _market = LatLng(1.3489789224691462, 103.93406345620501);
  static const _school = LatLng(1.341201097860117, 103.96365769997426);
  static const _initialPosition = CameraPosition(
    target: _home,
    zoom: 13.0,
  );

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void _zoomToLocation(LatLng location) {
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: location, zoom: 17.0),
      ),
    );
  }

  void _resetView() {
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(_initialPosition),
    );
  }

  List<Widget> _pages() => <Widget>[
        GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: _initialPosition,
          //displays the markers for the saved locations
          markers: {
            Marker(
              markerId: MarkerId('School'),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueGreen),
              position: _school,
            ),
            Marker(
              markerId: MarkerId('Market'),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueMagenta),
              position: _market,
            ),
            Marker(
              markerId: MarkerId('Home'),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueRed),
              position: _home,
            )
          },
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Locations'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _resetView,
          ),
        ],
      ),
      body: Column(children: [
        SizedBox(
          height: 400,
          width: 400,
          child: _pages().elementAt(_selectedIndex),
        ),
        SizedBox(height: 10),
        Card(
          clipBehavior: Clip.hardEdge,
          child: InkWell(
            splashColor: Colors.blue.withAlpha(30),
            onTap: () {
              _zoomToLocation(_school);
            },
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              ListTile(
                leading: Image.asset('assets/images/greenPin.png'),
                title: Text('School'),
                subtitle: Text('Singapore University of Technology and Design, 8 Somapah Rd'),
              ),
            ]),
          ),
        ),
        Card(
          child: InkWell(
            splashColor: Colors.blue.withAlpha(30),
            onTap: () {
              _zoomToLocation(_market);
            },
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              ListTile(
                leading: Image.asset('assets/images/magentaPin.png'),
                title: Text('Market'),
                subtitle: Text(
                    'Prime Supermarket, Tampines Street 81'),
              ),
            ]),
          ),
        ),
        Card(
          child: InkWell(
            splashColor: Colors.blue.withAlpha(30),
            onTap: () {
              _zoomToLocation(_home);
            },
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              ListTile(
                leading: Image.asset('assets/images/redPin.png'),
                title: Text('Home'),
                subtitle: Text(
                    'Blk 188 Pasir Ris St 12'),
              ),
            ]),
          ),
        ),
      ]),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: Text('HAHA'),
              content: Text('no u'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('OK'),
                ),
              ],
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Location'),
      ),
    );
  }
}
