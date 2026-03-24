import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ConquestMap extends StatefulWidget {
  const ConquestMap({super.key});

  @override
  State<ConquestMap> createState() => _ConquestMapState();
}

class _ConquestMapState extends State<ConquestMap> {
  final Set<Polygon> _polygons = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Eden Conquest: Global War'),
        backgroundColor: Colors.green.shade800,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: const CameraPosition(
              target: LatLng(20.0, 0.0),
              zoom: 2,
            ),
            polygons: _polygons,
            mapType: MapType.normal,
          ),
          _buildLeaderboard(),
        ],
      ),
    );
  }

  Widget _buildLeaderboard() {
    return Positioned(
      top: 10,
      right: 10,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Top Countries',
              style: TextStyle(
                  color: Colors.greenAccent, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 4),
            Text('1. Myanmar 🇲🇲', style: TextStyle(color: Colors.white)),
            Text('2. Brazil 🇧🇷', style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
