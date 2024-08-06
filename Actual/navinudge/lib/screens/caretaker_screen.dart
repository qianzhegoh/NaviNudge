import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CaretakerOverview extends StatefulWidget {
  const CaretakerOverview({Key? key}) : super(key: key);

  @override
  _CaretakerOverviewState createState() => _CaretakerOverviewState();
}

class _CaretakerOverviewState extends State<CaretakerOverview> {
  int _selectedIndex = 0;
  late GoogleMapController mapController;

  //sets the location of the saved locations
  static const _son = LatLng(1.341396268634156, 103.9636949477829);
  static const _mother = LatLng(1.3431723510678102, 103.9532351159952);
  static const _father = LatLng(1.3525386564949866, 103.94464626462255);
  static const _initialPosition = CameraPosition(
    target: _mother,
    zoom: 14.0,
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
                  BitmapDescriptor.hueRed),
              position: _son,
            ),
            Marker(
              markerId: MarkerId('Market'),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueGreen),
              position: _father,
            ),
            Marker(
              markerId: MarkerId('Home'),
              icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueMagenta),
              position: _mother,
            )
          },
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('People'),
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
              _zoomToLocation(_father);
            },
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              ListTile(
                leading: Image.asset('assets/images/greenPin.png'),
                title: Text('Father'),
                subtitle: Text('Currently at Tampines Mall'),
              ),
            ]),
          ),
        ),
        Card(
          child: InkWell(
            splashColor: Colors.blue.withAlpha(30),
            onTap: () {
              _zoomToLocation(_mother);
            },
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              ListTile(
                leading: Image.asset('assets/images/magentaPin.png'),
                title: Text('Mother'),
                subtitle: Text(
                    'Currently on MRT (EWL), headed towards Tampines [5 minutes]'),
              ),
            ]),
          ),
        ),
        Card(
          child: InkWell(
            splashColor: Colors.blue.withAlpha(30),
            onTap: () {
              _zoomToLocation(_son);
            },
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              ListTile(
                leading: Image.asset('assets/images/redPin.png'),
                title: Text('Son'),
                subtitle: Text(
                    'Currently at Singapore University of Techology and Design'),
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
        label: const Text('Add User'),
      ),
    );
  }
}
