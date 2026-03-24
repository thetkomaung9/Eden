import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import '../providers/user_provider.dart';
import 'map_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<UserProvider>(context, listen: false).initPedometer();
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);
    final stepProgress = (user.steps % 10000) / 10000;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Eden - Daily Impact'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 30),
        child: Column(
          children: [
            CircularPercentIndicator(
              radius: 120.0,
              lineWidth: 15.0,
              percent: stepProgress,
              progressColor: Colors.green,
              backgroundColor: Colors.grey.shade200,
              circularStrokeCap: CircularStrokeCap.round,
              center: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.directions_walk,
                      size: 50, color: Colors.green),
                  Text(
                    '${user.steps}',
                    style: const TextStyle(
                        fontSize: 40, fontWeight: FontWeight.bold),
                  ),
                  const Text('Steps Today'),
                ],
              ),
            ),
            const SizedBox(height: 40),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Card(
                elevation: 4,
                child: ListTile(
                  leading:
                      const Icon(Icons.stars, color: Colors.orange, size: 40),
                  title: const Text('Karma Points Earned'),
                  trailing: Text(
                    '${user.points}',
                    style: const TextStyle(
                        fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const WorldMapScreen()),
              ),
              icon: const Icon(Icons.public),
              label: const Text('View World Conquest Map'),
              style:
                  ElevatedButton.styleFrom(padding: const EdgeInsets.all(15)),
            ),
          ],
        ),
      ),
    );
  }
}
