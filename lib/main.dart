import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:camera/camera.dart';
import 'firebase_options.dart';
import 'providers/user_provider.dart';
import 'providers/game_provider.dart';
import 'screens/conquest_map.dart';

List<CameraDescription> cameras = [];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    cameras = await availableCameras();
  } catch (e) {
    debugPrint('Camera init error: $e');
  }

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const EdenApp());
}

class EdenApp extends StatelessWidget {
  const EdenApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => GameProvider()),
      ],
      child: MaterialApp(
        title: 'Eden',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          brightness: Brightness.dark,
          primaryColor: Colors.greenAccent,
          useMaterial3: true,
        ),
        home: const ConquestMap(),
      ),
    );
  }
}
