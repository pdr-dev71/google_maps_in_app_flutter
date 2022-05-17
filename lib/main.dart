import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'src/locations.dart' as locations;

void main() {
  runApp(const MaterialApp(
    home: GoogleMapsApp(),
  ));
}

class GoogleMapsApp extends StatefulWidget {
  const GoogleMapsApp({Key? key}) : super(key: key);

  @override
  State<GoogleMapsApp> createState() => _GoogleMapsAppState();
}

class _GoogleMapsAppState extends State<GoogleMapsApp> {
  final Map<String, Marker> _markers = {};
  Future<void> _onMapCreated(GoogleMapController controller) async {
    final googleOffices = await locations.getGoogleOffices();
    setState(() {
      _markers.clear();
      for (final office in googleOffices.offices) {
        final marker = Marker(
          markerId: MarkerId(office.name),
          position: LatLng(office.lat, office.lng),
          infoWindow: InfoWindow(
            title: office.name,
            snippet: office.address,
          ),
        );
        _markers[office.name] = marker;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Google Maps Example"),
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: const CameraPosition(
          target: LatLng(0, 0),
          zoom: 3,
        ),
        markers: _markers.values.toSet(),
      ),
    );
  }
}
