import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class GameProvider with ChangeNotifier {
  int _personalPoints = 0;

  int get points => _personalPoints;

  final _db = FirebaseFirestore.instance;

  Future<void> recordPlanting(
      String userId, String countryCode, String guildId) async {
    _personalPoints += 500;
    notifyListeners();

    // update user points
    await _db
        .collection('users')
        .doc(userId)
        .update({'points': FieldValue.increment(500)});

    // update country green score
    await _db
        .collection('countries')
        .doc(countryCode)
        .update({'greenScore': FieldValue.increment(500)});

    // update guild tree count if user is in one
    if (guildId.isNotEmpty) {
      await _db
          .collection('guilds')
          .doc(guildId)
          .update({'totalTrees': FieldValue.increment(1)});
    }
  }
}
