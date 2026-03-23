import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pedometer/pedometer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProvider with ChangeNotifier {
  int _steps = 0;
  int _points = 0;
  Timer? _syncTimer;
  String userId = "test_user_123"; // နောက်မှ Auth နဲ့ ချိတ်ပါမယ်

  int get steps => _steps;
  int get points => _points;

  void initPedometer() {
    Pedometer.stepCountStream.listen(
      _onStepCount,
      onError: (error) => print("Pedometer Error: $error"),
    );
  }

  void _onStepCount(StepCount event) {
    _steps = event.steps;
    _points = (_steps / 100).floor();
    notifyListeners();
    _scheduleSync();
  }

  void _scheduleSync() {
    _syncTimer?.cancel();
    _syncTimer = Timer(const Duration(seconds: 5), () {
      _updateFirestore();
    });
  }

  Future<void> _updateFirestore() async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'steps': _steps,
        'points': _points,
        'lastUpdated': FieldValue.serverTimestamp(),
        'country': 'Myanmar',
      }, SetOptions(merge: true));
      print("Data Synced!");
    } catch (e) {
      print("Sync Error: $e");
    }
  }
}
