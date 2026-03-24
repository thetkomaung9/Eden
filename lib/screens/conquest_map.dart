import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../models/cam_model.dart';
import '../widgets/cam_viewer.dart';

class ConquestMap extends StatefulWidget {
  const ConquestMap({super.key});
  @override
  State<ConquestMap> createState() => _ConquestMapState();
}

class _ConquestMapState extends State<ConquestMap> {
  String? _mapStyle;
  GoogleMapController? _mapController;

  @override
  void initState() {
    super.initState();
    _loadMapStyle();
    // App စတက်တာနဲ့ Data စဆွဲရန်
    Future.microtask(() => Provider.of<GameProvider>(context, listen: false)
        .streamKarmaPosts()
        .first);
  }

  Future<void> _loadMapStyle() async {
    final style = await rootBundle.loadString('assets/dark_map_style.json');
    if (mounted) setState(() => _mapStyle = style);
  }

  void _showCamPlayer(PublicCam cam) {
    showDialog(context: context, builder: (context) => CamViewer(cam: cam));
  }

  @override
  Widget build(BuildContext context) {
    final gameProvider = Provider.of<GameProvider>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition:
                const CameraPosition(target: LatLng(20.0, 0.0), zoom: 2),
            onMapCreated: (controller) {
              _mapController = controller;
              if (_mapStyle != null) _mapController!.setMapStyle(_mapStyle);
            },
            markers: gameProvider.getCombinedMarkers(context, _showCamPlayer),
            myLocationEnabled: true,
          ),

          // Top Info Dashboard
          _buildTopPanel(),

          // Bottom Country Rankings
          _buildRankingPanel(gameProvider),
        ],
      ),
    );
  }

  Widget _buildTopPanel() {
    return Positioned(
      top: 60,
      left: 20,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.8),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.greenAccent, width: 0.8),
          boxShadow: [
            BoxShadow(
                color: Colors.greenAccent.withOpacity(0.3), blurRadius: 10)
          ],
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('GLOBAL EDEN MONITOR',
                style: TextStyle(
                    color: Colors.greenAccent,
                    letterSpacing: 1.5,
                    fontSize: 10)),
            SizedBox(height: 5),
            Text('1,245,780 TREES',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold)),
            Text('LIVE SATELLITE FEED ACTIVE',
                style: TextStyle(
                    color: Colors.redAccent,
                    fontSize: 9,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildRankingPanel(GameProvider provider) {
    return Positioned(
      bottom: 40,
      left: 0,
      right: 0,
      child: SizedBox(
        height: 70,
        child: StreamBuilder(
          stream: provider.streamCountryRankings(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return const SizedBox();
            return ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final country = snapshot.data![index];
                return Container(
                  margin: const EdgeInsets.only(right: 12),
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.8),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Center(
                    child: Text(
                        "${country.countryName} : ${country.totalGreenScore} pts",
                        style:
                            const TextStyle(color: Colors.white, fontSize: 13)),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
