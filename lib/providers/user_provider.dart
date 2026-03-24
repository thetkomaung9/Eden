import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProvider with ChangeNotifier {
  int _steps = 0;
  int _points = 0;
  Timer? _syncTimer;

  // TODO: replace with real auth user id
  String userId = 'test_user_123';

  int get steps => _steps;
  int get points => _points;

  void initPedometer() {
    Pedometer.stepCountStream.listen(
      _onStepCount,
      onError: (e) => debugPrint('Pedometer error: $e'),
    );
  }

  void _onStepCount(StepCount event) {
    _steps = event.steps;
    _points = (_steps / 100).floor();
    notifyListeners();
    _scheduleSync();
  }

  // debounce syncing so we don't hammer firestore on every step
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
}
