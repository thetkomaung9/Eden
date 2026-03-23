import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class WorldMapScreen extends StatelessWidget {
  const WorldMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("World Conquest Map")),
      body: const GoogleMap(
        initialCameraPosition:
            CameraPosition(target: LatLng(21.9162, 95.9560), zoom: 3),
        mapType: MapType.hybrid,
        myLocationEnabled: true,
      ),
    );
  }
}
