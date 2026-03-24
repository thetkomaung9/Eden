import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProvider with ChangeNotifier {
  int _steps = 0;
  int _points = 0;
  Timer? _syncTimer;
  StreamSubscription? _sensorSub;

  // TODO: replace with real auth user id
  String userId = 'test_user_123';

  int get steps => _steps;
  int get points => _points;

  void initPedometer() {
    _sensorSub = accelerometerEventStream().listen(
      _onAccelerometer,
      onError: (e) => debugPrint('Sensor error: $e'),
    );
  }

  void _onAccelerometer(AccelerometerEvent event) {
    final magnitude = sqrt(
      event.x * event.x + event.y * event.y + event.z * event.z,
    );
    // rough step detection — magnitude spike above normal gravity
    if (magnitude > 12.0) {
      _steps++;
      _points = (_steps / 100).floor();
      notifyListeners();
      _scheduleSync();
    }
  }

  void _scheduleSync() {
    _syncTimer?.cancel();
    _syncTimer = Timer(const Duration(seconds: 5), _syncToFirestore);
  }

  Future<void> _syncToFirestore() async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'steps': _steps,
        'points': _points,
        'lastUpdated': FieldValue.serverTimestamp(),
        'country': 'Myanmar',
      }, SetOptions(merge: true));
    } catch (e) {
      debugPrint('Sync error: $e');
    }
  }

  @override
  void dispose() {
    _sensorSub?.cancel();
    _syncTimer?.cancel();
    super.dispose();
  }
}
