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

  var markers;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  List<Widget> _pages() => <Widget>[
        GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _mother,
              zoom: 14.0,
            ),
            //displays the markers for the saved locations
            markers: {
              Marker(
                  markerId: MarkerId('School'),
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueRed),
                  position: _son),
              Marker(
                  markerId: MarkerId('Market'),
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueGreen),
                  position: _father),
              Marker(
                markerId: MarkerId('Home'),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueMagenta),
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
        SizedBox(height: 10),
        Card(
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          ListTile(
            leading: Image.asset('assets/images/greenPin.png'),
            title: Text('Father'),
            subtitle: Text('Currently at Tampines Mall'),
          ),
        ])),
        Card(
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          ListTile(
            leading: Image.asset('assets/images/magentaPin.png'),
            title: Text('Mother'),
            subtitle: Text(
                'Currently on MRT (EWL), headed towards Tampines [5 minutes]'),
          ),
        ])),
        Card(
            child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
          ListTile(
            leading: Image.asset('assets/images/redPin.png'),
            title: Text('Son'),
            subtitle: Text(
                'Currently at Singapore University of Techology and Design'),
          ),
        ]))
      ]),
    );
  }
}
