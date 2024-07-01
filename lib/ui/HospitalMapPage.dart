import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HospitalMapPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Geolocalização de Hospitais'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(37.42796133580664, -122.085749655962),
          zoom: 14.0,
        ),
        markers: {
          Marker(
            markerId: MarkerId('hospital_marker'),
            position: LatLng(37.42796133580664, -122.085749655962),
            infoWindow: InfoWindow(
              title: 'Hospital Example',
              snippet: 'Descrição do Hospital',
            ),
          ),
          // Adicione mais marcadores conforme necessário
        },
      ),
    );
  }
}
