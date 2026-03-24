import 'dart:math';

class GameEngine {
  // checks if the accelerometer reading looks like real walking
  // vs someone just shaking their phone to cheat
  static bool isLegitMovement(double x, double y, double z) {
    final magnitude = sqrt(x * x + y * y + z * z);
    // normal walking sits roughly between 2.0 and 12.0
    return magnitude > 2.0 && magnitude < 12.0;
  }

  // 500 points per tree planted
  static int calculatePlantingPoints(int treeCount) {
    return treeCount * 500;
  }
}
